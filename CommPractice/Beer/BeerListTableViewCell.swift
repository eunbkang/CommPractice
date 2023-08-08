//
//  BeerListTableViewCell.swift
//  CommPractice
//
//  Created by Eunbee Kang on 2023/08/08.
//

import UIKit

class BeerListTableViewCell: UITableViewCell {
    static let identifier = "BeerListTableViewCell"
    
    @IBOutlet var beerImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var tagLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!

    var beer: Beer?
    
    func configUI() {
        guard let beer else { return }
     
        nameLabel.text = beer.name
        tagLabel.text = beer.tag
        descriptionLabel.text = beer.description
        
        guard let url = URL(string: beer.imageUrl) else {
            beerImageView.image = UIImage(systemName: "mug.fill")
            beerImageView.tintColor = .lightGray
            return
        }
        beerImageView.load(url: url)
    }
}
