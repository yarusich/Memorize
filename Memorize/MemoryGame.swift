//
//  MemoryGame.swift
//  Memorize
//
//  Created by Антон Сафронов on 25.08.2020.
//  Copyright © 2020 Антон Сафронов. All rights reserved.
//

import Foundation


struct MemoryGame <CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    
    var score: Int = 0
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get {
            cards.indices.filter {
                index in cards[index].isFaceUp
            }
            .only
        }
        //
        //            var faceUpCardIndices = [Int]()
        //            for index in cards.indices {
        //                if cards[index].isFaceUp == true {
        //                   faceUpCardIndices.append(index)
        //                }
        //            }
        //            if faceUpCardIndices.count == 1 {
        //                return faceUpCardIndices.first
        //            } else {
        //                return nil
        //            }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
//                if index == newValue {
//                    cards[index].isFaceUp = true
//                } else {
//                    cards[index].isFaceUp = false
//                }
            }
        }
    }
    
    //    счёт
    //    mutating func counting(cardOne: Card, cardTwo: Card) {
    //        if cardOne.isSeen, cardTwo.isSeen {
    //            score -= 1
    //        } else {
    //            score += 2
    //        }
    //        print(score)
    //    }
    
    //mutating т.к. мы изменяем self
    mutating func choose(card: Card) {
        print("card chosen \(card)")
        //получаем индекс карты в массиве с помощью функции firstIndex
        if let chosenIndex = cards.firstIndex(matching: card),
           //пока карта лицом к нам (или она совпала) - мы не обращаем на неё внимаение при тапе
                                !cards[chosenIndex].isFaceUp,
                                !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true

                    // MARK: - переделать подсчёт (func counting)
                    score += 2
                    print(score)
                }
                self.cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    }
        
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        
        for pairIndex in 0..<numberOfPairsOfCards {
            let content: CardContent = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        //перемешивает элементы массива
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        
        var isMatched: Bool = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        var content: CardContent
        var id: Int
        var isSeen: Bool = false
    
        // MARK: - Bonus Time
        var bonusTimeLimit: TimeInterval = 6
        
        private var faceUpTime: TimeInterval {
            if let lastFaceUpData = lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpData)
            } else {
                return pastFaceUpTime
            }
        }
        
        var lastFaceUpDate: Date?
        
        var pastFaceUpTime: TimeInterval = 0
        
        var bonusTimeRemaning: TimeInterval {
            max(0, bonusTimeLimit - pastFaceUpTime)
        }
        
        var bonusRemaning: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaning > 0) ? bonusTimeRemaning/bonusTimeLimit : 0
        }
        
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaning > 0
        }
        
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaning > 0
        }
        
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
    }
    
}
