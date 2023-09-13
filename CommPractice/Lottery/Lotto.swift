//
//  Lotto.swift
//  CommPractice
//
//  Created by Eunbee Kang on 2023/08/08.
//

import Foundation

struct Lotto: Codable {
    var round: Int
    var date: String
    var drwtNo1, drwtNo2, drwtNo3, drwtNo4, drwtNo5, drwtNo6, bnusNo: Int
    
    enum CodingKeys: String, CodingKey {
        case date = "drwNoDate"
        case round = "drwNo"
        case drwtNo1, drwtNo2, drwtNo3, drwtNo4, drwtNo5, drwtNo6, bnusNo
    }
}
