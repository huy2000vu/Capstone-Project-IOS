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
        return stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath) as! stockCell
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        cell.addGestureRecognizer(swipeGesture)
        let stock = stocks[indexPath.row]
//        cell.textLabel?.text = stock.T
        let priceChange =  (stock.c - stock.o)
        let percentageChange =  String(format: "%.2f", (priceChange/stock.o)*100)
        cell.stockTicker.text = "$\(stock.T)"
        cell.stockVolume.text = "\(stock.v)"
        cell.stockPrice.text = "$\(stock.c)"
        if (priceChange) > 0 {
            cell.dailyChange.text = "+"+currencyDecimalConv(val: priceChange)+" "+"(+"+percentageChange+"%)"
            cell.backgroundColor = UIColor(red: 0.62, green: 0.87, blue: 0.76, alpha: 1.0)
        }
        else{
            cell.dailyChange.text = currencyDecimalConv(val: priceChange)+" ("+percentageChange+"%)"
            cell.backgroundColor = UIColor(red: 0.86, green: 0.08, blue: 0.24, alpha: 1.0)
        }
        return cell
    }
    
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer)
    {
        if let cell = gesture.view as? UITableViewCell{
            if let indexPath = tableview.indexPath(for: cell)
            {
                let stock = stocks[indexPath.row]
                // Get the index path of the cell
                if let indexPath = tableview.indexPath(for: cell) {
                    // Perform actions based on the swipe direction
                    switch gesture.direction {
                    case .left:
                        // Handle left swipe
                        print("Left swipe detected for cell at index path: \(indexPath)")
                    case .right:
                        // Handle right swipe
                        stock.addToWatchList()
                        print("\(stock.T) was added to watch list")
                        UIView.animate(withDuration: 0.3, animations: {
                            cell.transform =  CGAffineTransform(translationX: cell.bounds.width, y: 0)
                        }) {(_) in  UIView.animate(withDuration: 0.3) {
                            cell.transform = .identity
                        } }
                    default:
                        break
                    }
                    
                }
            }
        }
    }
    
    func currencyDecimalConv(val: Double) -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_us")
        return formatter.string(from: NSNumber(value: val)) ?? ""
    }
    
    func getDate(day: Int) -> String{ //return 2 days before the current day because API won't fetch real time data as a free tier
        let currentDate = Date()
        let dateformatter = DateFormatter()
        var dateComponent = DateComponents()
        let calendar = Calendar.current
        
        dateComponent.day = day
        
        guard var adjustedDate = calendar.date(byAdding: dateComponent, to: currentDate) else {
            return "Date Error"
        }
        
        if let weekday = calendar.dateComponents([.weekday], from: adjustedDate).weekday{
            switch weekday {
            case 1: // Sunday
                adjustedDate = calendar.date(byAdding: .day, value: -2, to: adjustedDate)!
            case 7: // Saturday
                adjustedDate = calendar.date(byAdding: .day, value: -1, to: adjustedDate)!
            default:
                break // No adjustment needed if it's not a weekend
            }
        }
        dateformatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateformatter.string(from: adjustedDate)
        return formattedDate
    }
    
    func fetchData(){
        let apiKey = "oXZyWKJSMmfQOoi1t2eTiXSb4sXRaXvU"
        let dateString =  getDate(day:-1) //"2024-04-15"
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
                DispatchQueue.main.async { [weak self] in
                    aggregates.results.sort(by: { $0.v > $1.v })
                    for aggregate in aggregates.results {
                        print("Ticker: \(aggregate.T), Volume: \(aggregate.v)")
                    }
                    let stocks = aggregates.results
                    self?.stocks = stocks
                    self?.tableview.reloadData()
                    
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
        print(getDate(day:-1))
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

