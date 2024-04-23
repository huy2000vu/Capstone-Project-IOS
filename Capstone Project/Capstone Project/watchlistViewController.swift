import UIKit

class WatchlistViewController: UITableViewController {
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchlist.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath) as! stockCell
//
//        // Get the movie associated table view row
//        let stock = watchlist[indexPath.row]
//
//        
//        cell.stockTicker.text = "$\(stock.T)"
//        cell.stockVolume.text = "\(stock.v)"
//        cell.stockPrice.text = "$\(stock.c)"
//        return cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath) as! stockCell
//        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
//        cell.addGestureRecognizer(swipeGesture)
        let stock = watchlist[indexPath.row]
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
//    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer)
//    {
//        if let cell = gesture.view as? UITableViewCell{
//            if let indexPath = tableview.indexPath(for: cell)
//            {
//                let stock = watchlist[indexPath.row]
//                // Get the index path of the cell
//                if let indexPath = tableview.indexPath(for: cell) {
//                    // Perform actions based on the swipe direction
//                    switch gesture.direction {
//                    case .left:
//                        // Handle left swipe
//                        print("Left swipe detected for cell at index path: \(indexPath)")
//                    case .right:
//                        // Handle right swipe
//                        stock.addToWatchList()
//                        print("\(stock.T) was added to watch list")
//                        UIView.animate(withDuration: 0.3, animations: {
//                            cell.transform =  CGAffineTransform(translationX: cell.bounds.width, y: 0)
//                        }) {(_) in  UIView.animate(withDuration: 0.3) {
//                            cell.transform = .identity
//                        } }
//                      
//                    default:
//                        break
//                    }
//                    
//                }
//            }
//        }
//    }

    
    func currencyDecimalConv(val: Double) -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_us")
        return formatter.string(from: NSNumber(value: val)) ?? ""
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        // MARK: - Pass the selected movie to the Detail View Controller
//
//        // Get the index path for the selected row.
//        // `indexPathForSelectedRow` returns an optional `indexPath`, so we'll unwrap it with a guard.
//        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
//
//        // Get the selected movie from the movies array using the selected index path's row
//        let selectedMovie = favoriteMovies[selectedIndexPath.row]
//
//        // Get access to the detail view controller via the segue's destination. (guard to unwrap the optional)
//        guard let detailViewController = segue.destination as? DetailViewController else { return }
//
//        detailViewController.movie = selectedMovie
//    }
}
