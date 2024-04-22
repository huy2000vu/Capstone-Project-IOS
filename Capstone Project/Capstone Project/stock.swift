//
//  stock.swift
//  Capstone Project
//
//  Created by X Y on 4/15/24.
//

import Foundation

struct Aggregates: Decodable{
    var results: [stock]
}
struct stock: Decodable,Encodable, Equatable{
    let T: String // Ticker symbol
    let v: Double // Volume
    let o: Double // Open
    let c: Double // Close
    let h: Double // High
    let l: Double // Low
//    let prevClose: Double //close from the previous day
}
extension stock{
    static var favoriteKey: String{
        return "Favorites"
    }
    
    static func save(_ stocks: [stock], forkey key:String)
    {
        let defaults = UserDefaults.standard
        let encodedData = try! JSONEncoder().encode(stocks)
        defaults.set(encodedData, forKey: key)
    }
    static func getStocks(forkey key:String) -> [stock]{
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: key){
            let decodedStock = try! JSONDecoder().decode([stock].self, from: data)
            return decodedStock
        }
        else{
            return []
        }
    }
    func addToWatchList(){
        var favoriteStock = stock.getStocks(forkey: stock.favoriteKey)
        favoriteStock.append(self)
        stock.save(favoriteStock, forkey: stock.favoriteKey)
    }
    func removeFromWatchList(){
        var favoriteStock = stock.getStocks(forkey: stock.favoriteKey)
        favoriteStock.removeAll {stock in
            return self == stock
        }
        stock.save(favoriteStock, forkey: stock.favoriteKey)
    }
}
