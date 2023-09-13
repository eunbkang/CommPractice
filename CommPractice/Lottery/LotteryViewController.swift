//
//  LotteryViewController.swift
//  CommPractice
//
//  Created by Eunbee Kang on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON

class LotteryViewController: UIViewController {

    @IBOutlet var searchField: UITextField!
    @IBOutlet var roundLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var numberLabels: [UILabel]!
    
    let pickerView = UIPickerView()
    
    let viewModel = LottoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        searchField.inputView = pickerView
        
        viewModel.roundText.bind { round in
            self.roundLabel.text = round
        }
        viewModel.date.bind { text in
            self.dateLabel.text = text
        }
        viewModel.numbersText.bind { numbers in
            guard let numbers else { return }
            if numbers.count > 0 {
                for i in 0...numbers.count - 1 {
                    self.numberLabels[i].text = numbers[i]
                }
            }
        }
        
        viewModel.fetchLotto()
    }
}

extension LotteryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.roundList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        viewModel.roundText.value = viewModel.roundList[row]
        viewModel.fetchLotto()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return viewModel.roundList[row]
    }
}

extension LotteryViewController {
    func configUI() {
        for label in numberLabels {
            label.font = .systemFont(ofSize: 17, weight: .bold)
            
            if label.tag == 6 {
                label.textColor = .blue
            }
        }
    }
}
