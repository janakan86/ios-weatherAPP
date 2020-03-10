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
    
    
   // let data = [ "Geelong" , "Melbourne", "Sydney","Brisbane"]
    
    var filteredData:[String]! = []
    
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
        
        guard searchText.count > 0 else{
            return
        }
        
        if !searchText.isEmpty{
            if (searchText.count > 1 ){
                fetchLocations(searchword:searchText)
            }
            self.tableView.reloadData()
        }
    
    }
    
    func resetCurrentDataSource(){
        self.filteredData.removeAll()
        tableView.reloadData()
    }
    
    func fetchLocations(searchword:String){
        DataService.sharedDataService.fetchLocations(
            
            successCallback:{ (citylocations:[accuweatherCity]?)->() in

                guard let retrievedCitylocations = citylocations, let unwrappedFilteredData = self.filteredData else{
                    return
                }
                
                self.filteredData.removeAll()
                
                for location in retrievedCitylocations {
                    self.filteredData.append(location.LocalizedName)
                    //print(location.LocalizedName)
                }

                
        },searchWord:searchword
        )
        
    }
    

}


extension SearchViewController : UISearchResultsUpdating {
    //a function in the UISearchResultsUpdating protocol
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text{
            filterCurrentDataSource(searchText: searchText)
        }
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

        if(searchText.count>2){
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
            cell.textLabel?.text = self.filteredData[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title:"Selection",message:"Selected: \(filteredData[indexPath.row])",preferredStyle: .alert)
        
        searchController.isActive = false
        let okAction = UIAlertAction(title:"OK",style: .default, handler:nil)
        alertController.addAction(okAction)
        present(alertController, animated:true,completion:nil)
    }
    
    
    
    
}
