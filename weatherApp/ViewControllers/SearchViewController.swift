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
    
    
    let data = [ "Geelong" , "Melbourne", "Sydney","Brisbane"]
    
    var filteredData:[String]!
    
    var searchController:UISearchController!
    
    var container: NSPersistentContainer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        filteredData = data
        
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
        
        self.filteredData = data.filter{$0.replacingOccurrences(of:" ",with:"").lowercased().contains(searchText.replacingOccurrences(of:" ",with:"").lowercased())}
        
        tableView.reloadData()
    
    }
    
    func restoreCurrentDataSource(){
        filteredData = data
        tableView.reloadData()
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
        searchController.isActive = false
        
        if let searchText = searchBar.text {
            filterCurrentDataSource(searchText: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        
        if let searchText = searchBar.text, !searchText.isEmpty {
            restoreCurrentDataSource()
        }
        
    }
}

extension SearchViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = filteredData[indexPath.row]
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
