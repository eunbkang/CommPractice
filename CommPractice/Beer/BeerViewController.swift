//
//  BeerViewController.swift
//  CommPractice
//
//  Created by Eunbee Kang on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON

class BeerViewController: UIViewController {

    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var beerImageView: UIImageView!
    @IBOutlet var beerNameLabel: UILabel!
    @IBOutlet var tagLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    var randomBeer: Beer? {
        didSet {
            setRandomBeerToView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        callRequest()
    }
    
    @IBAction func tappedAnotherBeerButton(_ sender: UIButton) {
        callRequest()
    }
    
    func callRequest() {
        
        let url = "https://api.punkapi.com/v2/beers/random"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                self.configBeer(json)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func configBeer(_ json: JSON) {
        let beerJson = json.arrayValue[0]
        
        let name = beerJson["name"].stringValue
        let tag = beerJson["tagline"].stringValue
        let imageUrl = beerJson["image_url"].stringValue
        let description = beerJson["description"].stringValue
        
        self.randomBeer = Beer(name: name, tag: tag, imageUrl: imageUrl, description: description)
    }
    
    func setRandomBeerToView() {
        guard let randomBeer else { return }
        beerNameLabel.text = randomBeer.name
        tagLabel.text = randomBeer.tag
        descriptionLabel.text = randomBeer.description
        
        guard let url = URL(string: randomBeer.imageUrl) else {
            beerImageView.image = UIImage(systemName: "mug.fill")
            beerImageView.tintColor = .lightGray
            return
        }
        beerImageView.load(url: url)
    }
}

extension BeerViewController {
    func configUI() {
        headerLabel.text = "오늘은 이 맥주 어떠세요?"
        
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
    }
}
