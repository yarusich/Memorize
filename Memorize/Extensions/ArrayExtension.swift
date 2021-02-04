//
//  ArrayExtension.swift
//  Memorize
//
//  Created by Антон Сафронов on 10.09.2020.
//  Copyright © 2020 Антон Сафронов. All rights reserved.
//

import Foundation

extension Array {
    func takeRandom(countOfCards countOfElements: Int, allEmojis array: Array<Element>) -> Array<Element> {
        return Array(array.shuffled().prefix(countOfElements))
    }
}

extension Array where Element: Identifiable {
    func firstIndex(matching: Element) -> Optional<Int> {
        for index in 0..<self.count {
            if self[index].id == matching.id {
                return index
            }
        }
        return nil
    }
}

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
