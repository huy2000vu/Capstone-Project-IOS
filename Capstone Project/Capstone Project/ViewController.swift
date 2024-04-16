//
//  ViewController.swift
//  Capstone Project
//
//  Created by X Y on 4/15/24.
//

import UIKit
import Foundation
class ViewController: UIViewController, UITableViewDataSource {
    private var stocks: [stock] = [] 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Row \(indexPath.row)"
        return cell
    }
    func getDate() -> String{
        let currentDate = Date()
        let dateformatter = DateFormatter()
        var dateComponent = DateComponents()
        let calendar = Calendar.current
        
        dateComponent.day = -1
        guard let pastDate = calendar.date(byAdding: dateComponent, to: currentDate) else {
            return "Date Error"
        }
        dateformatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateformatter.string(from: pastDate)
        return formattedDate
    }
    func fetchData(){
        let apiKey = "oXZyWKJSMmfQOoi1t2eTiXSb4sXRaXvU"
        let dateString =  getDate() //"2024-04-15"
        let urlString = "https://api.polygon.io/v2/aggs/grouped/locale/us/market/stocks/\(dateString)?adjusted=true&apiKey=\(apiKey)"
        guard let url = URL(string: urlString) else{
            fatalError("Invalid URL")
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let htttpResponse = response as? HTTPURLResponse, htttpResponse.statusCode == 200 else{
                print("Invalid response from server")
                return
            }
            guard let data = data else {
                print("no data")
                return
            }
            do {
                        let decoder = JSONDecoder()
                        var aggregates = try decoder.decode(Aggregates.self, from: data)
                        // Sort the results by volume in descending order right after decoding
                        aggregates.results.sort(by: { $0.v > $1.v })

                        // Print the sorted results
                        for aggregate in aggregates.results {
                            print("Ticker: \(aggregate.T), Volume: \(aggregate.v)")
                        }
                    } catch {
                        // Correct catch block syntax
                        print("Decoding error: \(error)")
                    }
                }
                task.resume()  // Don't forget to start the task!
            }


    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        tableview.dataSource = self
        fetchData()
//        print(getDate())
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

