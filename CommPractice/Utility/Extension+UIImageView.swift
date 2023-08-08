//
//  Extension+UIImageView.swift
//  CommPractice
//
//  Created by Eunbee Kang on 2023/08/08.
//

import UIKit

extension UIImageView {
    
    // Reference: https://hongssup.tistory.com/158
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            guard let data = try? Data(contentsOf: url) else { return }
            
            guard let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}
