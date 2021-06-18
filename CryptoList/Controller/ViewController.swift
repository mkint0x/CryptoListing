//
//  ViewController.swift
//  CryptoList
//
//  Created by Aqeel Ahmed on 29/05/2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var symLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    var cryptoManager = CryptoManager()
    var coinNames:[String] = []
    var coinSymbs:[String] = []
    var coinPrice:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        cryptoManager.delegate = self
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.resusableIdentifier, bundle: nil), forCellReuseIdentifier: K.resusableIdentifier)
        
        cryptoManager.fetchUrl()
        populateLabels()
        // Do any additional setup after loading the view.
    }
    
    func populateLabels(){
        titleLabel.text = K.titles.listingTitle
        nameLabel.text = K.titles.nameHead
        symLabel.text = K.titles.symHead
        priceLabel.text = K.titles.priceHead
    }
}

//MARK: - UITableViewDeletegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.resusableIdentifier, for: indexPath) as! TableViewCell
        cell.coinImageView.image = UIImage(named: K.coinLogos[indexPath.row])
        cell.coinNameLabel.text = coinNames[indexPath.row]
        cell.coinSymbolLabel.text = coinSymbs[indexPath.row]
        cell.coinPriceLabel.text = "$\(coinPrice[indexPath.row])"
        return cell
    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

//MARK: - CryptoManagerDelegate

extension ViewController:CryptoManagerDelegate {
    func didUpdateCrypto(cryptoModel: CryptoModel) {
        coinNames = cryptoModel.name
        coinSymbs = cryptoModel.symbol
        coinPrice = cryptoModel.price
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
