//
//  Card.swift
//  MatchCards
//
//  Created by punyawee  on 26/5/61.
//  Copyright © พ.ศ. 2561 Punyugi. All rights reserved.
//

import Foundation

class Card {
    var identifier: Int
    var isFilp: Bool
    var isMatch: Bool
    init(identifier i: Int) {
        isFilp = false
        isMatch = false
        identifier = i
    }
}
