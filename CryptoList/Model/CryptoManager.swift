//
//  CryptoManager.swift
//  CryptoList
//
//  Created by Aqeel Ahmed on 05/06/2021.
//

import Foundation
import UIKit

protocol CryptoManagerDelegate {
    func didUpdateCrypto(cryptoModel:CryptoModel)
}

struct CryptoManager {
    var delegate:CryptoManagerDelegate?

    func fetchUrl() {
        let url = "https://api.coinlore.net/api/tickers/?limit=15"
        performRequest(URLString: url)
    }
    func performRequest(URLString:String) {
        let urlString = URL(string: URLString)
        if let safeUrl = urlString {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: safeUrl) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    if let cryptoModel = parseJson(cryptoData: safeData) {
                        self.delegate?.didUpdateCrypto(cryptoModel: cryptoModel)
                    }
                    return
                }
            }
            task.resume()
        }
    }
    
    func parseJson(cryptoData:Data) -> CryptoModel? {
        let decoder = JSONDecoder()
        var coinNames:[String] = []
        var coinSymbs:[String] = []
        var coinPrice:[String] = []
        
        do {
            let decodedData = try decoder.decode(CryptoData.self, from: cryptoData)
            let dataNameCount = decodedData.data.count
            for n in Range(0...dataNameCount-1)  {
                coinNames.append(decodedData.data[n].name)
                coinSymbs.append(decodedData.data[n].symbol)
                coinPrice.append(decodedData.data[n].price_usd)
            }
            
            let cryptoModel = CryptoModel(name: coinNames, symbol: coinSymbs, price: coinPrice)
            return cryptoModel
        } catch {
            print(error)
            return nil
        }
    }

}
