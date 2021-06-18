//
//  CryptoModel.swift
//  CryptoList
//
//  Created by Aqeel Ahmed on 05/06/2021.
//

import Foundation


struct CryptoData:Decodable{
    var data:[cryptoData]
}

struct cryptoData:Decodable {
    var name:String
    var symbol:String
    var price_usd:String
}
