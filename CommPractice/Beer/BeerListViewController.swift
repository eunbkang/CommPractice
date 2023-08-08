//
//  BeerListViewController.swift
//  CommPractice
//
//  Created by Eunbee Kang on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON

class BeerListViewController: UIViewController {
    
    @IBOutlet var beerListTableView: UITableView!
    
    var beerList: [Beer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        beerListTableView.delegate = self
        beerListTableView.dataSource = self
        beerListTableView.rowHeight = 120
        
        callRequest()
    }
    
    @IBAction func tappedRandomBeerButton(_ sender: UIBarButtonItem) {
        let sb = UIStoryboard(name: "Beer", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: BeerViewController.identifier) as! BeerViewController
        
        present(vc, animated: true)
    }
    
    func callRequest() {
        
        let url = "https://api.punkapi.com/v2/beers"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                self.configBeerList(json)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func configBeerList(_ json: JSON) {
        let beerListJson = json.arrayValue
        
        for item in beerListJson {
            let name = item["name"].stringValue
            let tag = item["tagline"].stringValue
            let imageUrl = item["image_url"].stringValue
            let description = item["description"].stringValue
            
            let beer = Beer(name: name, tag: tag, imageUrl: imageUrl, description: description)
            
            beerList.append(beer)
        }
        beerListTableView.reloadData()
    }
}

extension BeerListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BeerListTableViewCell.identifier) as? BeerListTableViewCell else { return UITableViewCell() }
        
        cell.beer = beerList[indexPath.row]
        cell.configUI()
        
        return cell
    }
}
