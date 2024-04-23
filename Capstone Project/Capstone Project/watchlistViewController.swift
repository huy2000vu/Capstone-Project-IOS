//
//  WatchlistViewController.swift
//  Capstone Project
//
//  Created by X Y on 4/23/24.
//

import UIKit
class WatchlistViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    //    @IBOutlet weak var tableView: UITableView!
    var watchlist : [stock] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let stocks = stock.getStocks(forkey: stock.favoriteKey)
        self.watchlist = stocks
        tableView.reloadData()
    }
    
    // Implement UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath) as! stockCell
        let stock = watchlist[indexPath.row]
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
                if let indexPath = tableView.indexPath(for: cell)
                {
                    let stock = watchlist[indexPath.row]
                    // Get the index path of the cell
                    if let indexPath = tableView.indexPath(for: cell) {
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
}


