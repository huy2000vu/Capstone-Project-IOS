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
struct stock: Decodable{
    let T: String // Ticker symbol
    let v: Double // Volume
    let o: Double // Open
    let c: Double // Close
    let h: Double // High
    let l: Double // Low
}
