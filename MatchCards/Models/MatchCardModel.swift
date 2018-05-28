//
//  MathGame.swift
//  MatchCards
//
//  Created by punyawee  on 26/5/61.
//  Copyright © พ.ศ. 2561 Punyugi. All rights reserved.
//

import Foundation

class MatchCardModel {
    private var cards = [Card]()
    func getAllCards() -> [Card] {
        cards.shuffle()
        resetAllCards()
        return cards
    }
    func resetAllCards() {
        for card in cards {
            card.isFilp = false
            card.isMatch = false
        }
    }
    private func genCards(_ n: Int) {
        for i in 1...n {
            let firstCard = Card(identifier: i)
            let secondCard = Card(identifier: i)
            cards.append(firstCard)
            cards.append(secondCard)
        }
    }
    func isFinishedGame() -> Bool {
        for card in cards {
            if !card.isMatch {
                return false
            }
        }
        return true
    }
    init(numOfPairCards n: Int) {
        genCards(n)
    }
}

extension MutableCollection {
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}
