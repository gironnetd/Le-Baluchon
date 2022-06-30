//
//  SymbolsViewController.swift
//  Le Baluchon
//
//  Created by damien on 28/06/2022.
//

import UIKit

//
// MARK: - Symbols ViewController
//
class SymbolsViewController: UITableViewController {
    
    private var symbols: [String] = []
    
    weak var rootViewController: ExchangeViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "SymbolTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SymbolTableViewCell")
        
        ExchangeService.shared.retrieveData(
            from: ExchangeRequest(endPoint: .symbols), callBack: { symbols, error in
                guard error == nil else {
                    return
                }
                
                if let symbols = symbols {
                    self.symbols = symbols.map { (key, value) in key + " \(value)" }
                    self.symbols.sort(by: <)
                    self.tableView.reloadData()
                }
            })
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.symbols.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "SymbolTableViewCell", for: indexPath) as! SymbolTableViewCell
        cell.symbol.text = self.symbols[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rootViewController?.baseCurrency = String(self.symbols[indexPath.row].split(separator: " ")[0])
        dismiss(animated: true, completion: nil)
    }
    
    //setting header view
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x:0, y:0, width: tableView.frame.size.width, height: 50))
        headerView.backgroundColor = .brown
        let title = UILabel(frame: CGRect(x:10, y:10, width: tableView.frame.size.width, height: 50))
        title.text = "Choose your Currency :"
        title.textColor = .white
        title.font = UIFont.boldSystemFont(ofSize: 21)
        headerView.addSubview(title)
        
        title.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10).isActive = true
        title.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10).isActive = true
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}
