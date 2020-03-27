//
//  SearchViewController.swift
//  weatherApp
//
//  Created by K Janakan on 13/2/20.
//  Copyright © 2020 K Janakan. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController {
    
    
 
    @IBOutlet weak var tableView: UITableView!
    
    
    var filteredData:[RetrievedLocation]! = []
    
    var searchController:UISearchController!
    
    var container: NSPersistentContainer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       // filteredData = data
        
        //nil forces results to be shown in the same view controller
        searchController = UISearchController(searchResultsController:nil)
        searchController.searchResultsUpdater = self
        //searchContainerView.addSubview(searchController.searchBar)
        

        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        tableView.delegate = self
        tableView.dataSource = self
    
    }
    
    
    func filterCurrentDataSource (searchText:String){
        guard searchText.count > 2 else{
            return
        }
        
        fetchLocations(searchword:searchText)
        //self.tableView.reloadData()
        
    }
    
    func resetCurrentDataSource(){
        self.filteredData.removeAll()
        self.tableView.reloadData()
    }
    
    func fetchLocations(searchword:String){
        DataService.sharedDataService.fetchLocations(
            
            successCallback:{ (citylocations:[accuweatherCity]?)->() in

                guard let retrievedCitylocations = citylocations else{
                    return
                }
                
                self.filteredData.removeAll()
                
                
                for city in retrievedCitylocations {

                   self.filteredData.append( RetrievedLocation(city:city.LocalizedName,countryCode:city.Country.ID,                          countryName: city.Country.LocalizedName))
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                
        },
            errorCallback:{ (error:Error?)->() in
               self.resetCurrentDataSource()
                
        },
            searchWord:searchword
        )
        
    }
    
    
    func navigateToHome(){
        let storyBoard = UIStoryboard(name:"Main", bundle: nil)
        
        //identifier is the storyboard ID
        let vc = storyBoard.instantiateViewController(withIdentifier: "homeVC")
        navigationController?.pushViewController(vc, animated: true)
    }
    

}


extension SearchViewController : UISearchResultsUpdating {
    
    //a function in the UISearchResultsUpdating protocol
    func updateSearchResults(for searchController: UISearchController) {
         //We are using searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
         //kick off filtering. Therefore this is commented out
        /*
             if let searchText = searchController.searchBar.text{
                filterCurrentDataSource(searchText: searchText)
            }
         
         */
    }
}


extension SearchViewController: UISearchBarDelegate {
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let searchText = searchBar.text {
            self.filterCurrentDataSource(searchText: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        resetCurrentDataSource()
        searchBar.text = nil
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.count > 2){
            self.filterCurrentDataSource(searchText: searchText)
        }

    }
}

extension SearchViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        
        guard let unwrappedFilteredData = self.filteredData else{
            return cell
        }
    
        if unwrappedFilteredData.count > 0 {
            cell.textLabel?.text =  self.filteredData[indexPath.row].city + " - " +
                                    self.filteredData[indexPath.row].countryName
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        searchController.isActive = false
        
        //store the newly selected city as the default
        DataService.sharedDataService.deleteAllStoredCitites()
        DataService.sharedDataService.saveStoredCity(location : filteredData[indexPath.row])
        
        //navigate to home screen with the new city selected
        navigateToHome()
        

    }
    
}
