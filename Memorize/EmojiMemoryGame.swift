//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Антон Сафронов on 25.08.2020.
//  Copyright © 2020 Антон Сафронов. All rights reserved.
//

import SwiftUI
//(может быть наблюдаемым)
class EmojiMemoryGame: ObservableObject {
    
    var score: Int { model.score }
    
    func makeScore() -> Int {
         model.score
    }
    // MARK: - защита от дурака???
    static var theme = themes.randomElement()!
    static var themes: Array = [hell, animals,sports]
    
    static var hell: Theme = Theme(name: "Hell", color: .red, numberOfPairs: 9, arrayOfEmoji: ["👻", "🌚", "🎃", "👹", "🦴", "🤡", "😈", "😱", "💀", "👺", "🦇"])
    static var animals = Theme(name: "Animals", color: .yellow, numberOfPairs: 12, arrayOfEmoji: ["🐶", "🐱", "🐹", "🦊", "🐻", "🐼", "🦁", "🐺", "🐰", "🐨", "🐸", "🐻‍❄️", "🐯"])
    static var sports = Theme(name: "Sports", color: .blue, numberOfPairs: 6, arrayOfEmoji: ["⚽️", "🏀", "🏈", "🥎", "🏐", "🥌", "🎱", "🏓", "🏒"])
    
    
    //@Published обёртка свойства, вызывает каждый раз objectWillChange.send(), когда меняется model
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    // MARK: - Extra Credit 1
    
    private static func createMemoryGame() -> MemoryGame<String> {
        theme = themes.randomElement()!
        let numberOfPairs = theme.numberOfPairs
        let newEmojis = theme.arrayOfEmoji.takeRandom(countOfCards: numberOfPairs, allEmojis: theme.arrayOfEmoji)
        
        return MemoryGame<String>(numberOfPairsOfCards: numberOfPairs) {pairIndex in newEmojis[pairIndex]
            
        }
    }
    
    func restart() {
        model = EmojiMemoryGame.createMemoryGame()
    }
   
    // MARK: - Access to the Model
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    // MARK: - intent(s)
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
}


// MARK: - first version
//func randomEmojis(countOfCards countOfElements: Int, allEmojis array: Array<String>) -> Array<String> {
//    var newEmojis: Array<String> = []
//    var oldArrayEmojis = array
//    for _ in 1...countOfElements {
//        newEmojis.append(oldArrayEmojis.remove(at: Int.random(in: 0...oldArrayEmojis.count - 1)))
//    }
//    return newEmojis
//}



