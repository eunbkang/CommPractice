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
    
    var roundList: [Int] = Array(1...1079).reversed()
    var lotto: Lotto? {
        didSet {
            setLottoToView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        searchField.inputView = pickerView
        configUI()
        
        callRequest(round: roundList[0])
    }
    
    func callRequest(round: Int) {
        
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(round)"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                self.lotto = self.configLotto(json)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func configLotto(_ json: JSON) -> Lotto {
        let round = json["drwNo"].intValue
        let date = json["drwNoDate"].stringValue
        
        var numbers: [Int] = []
        
        for i in 1...6 {
            numbers.append(json["drwtNo\(i)"].intValue)
        }
        numbers.append(json["bnusNo"].intValue)
        
        return Lotto(round: round, date: date, numbers: numbers)
    }
    
    func setLottoToView() {
        guard let lotto else { return }
        
        roundLabel.text = "\(lotto.round)회"
        dateLabel.text = lotto.date
        
        for i in 0...lotto.numbers.count - 1 {
            numberLabels[i].text = "\(lotto.numbers[i])"
        }
    }
}

extension LotteryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return roundList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let selectedRound = roundList[row]
        roundLabel.text = "\(selectedRound)"
        
        callRequest(round: selectedRound)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return "\(roundList[row])"
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
