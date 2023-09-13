//
//  LottoViewModel.swift
//  CommPractice
//
//  Created by Eunbee Kang on 2023/09/13.
//

import Foundation

class LottoViewModel {
    
    var lotto: Lotto?
    var roundList: [String] = Array(1...1084).reversed().map { String($0) }
    
    var date: Observable<String?> = Observable("")
    var roundText = Observable("1084")
    var numbersText: Observable<[String]?> = Observable([])
    
    func fetchLotto() {
        guard let url = URL(string: "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(roundText.value)") else { return }
        
        APIService.shared.callRequest(url: url, model: Lotto.self) { lotto in
            guard let lotto = lotto else { return }
            self.lotto = lotto
            self.convertDataToProperties()
        }
    }
    
    private func convertDataToProperties() {
        date.value = lotto?.date
        numbersText.value = getNumbers()
    }
    
    private func getNumbers() -> [String] {
        var numbersString: [String] = []
        
        guard let lotto = lotto else { return [] }
        let numbers = [lotto.drwtNo1, lotto.drwtNo2, lotto.drwtNo3, lotto.drwtNo4, lotto.drwtNo5, lotto.drwtNo6, lotto.bnusNo]
        
        for number in numbers {
            let numberString = String(number)
            numbersString.append(numberString)
        }
        
        return numbersString
    }
}
