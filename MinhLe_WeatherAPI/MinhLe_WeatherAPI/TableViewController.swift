//
//  TableViewController.swift
//  MinhLe_WeatherAPI
//
//  Created by Minh Le on 2021-04-03.
//

import Foundation
import Combine
class TableViewController : UITableViewController{
    private let launchesFetcher = LaunchesFetcher.getInstance()
    private var weatherList : [Weather] = [Weather]()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.launchesFetcher.fetchDataFromAPI()
        self.receiveChanges()
        
        self.tableView.rowHeight = 210
        self.tableView.reloadData()
    }
    
    private func receiveChanges(){
        self.launchesFetcher.$weatherList.receive(on: RunLoop.main)
            .sink{(launch) in
                print(#function, "Received Launch : ", launch)
                self.weatherList.removeAll()
                self.weatherList.append(contentsOf: launch)
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}
