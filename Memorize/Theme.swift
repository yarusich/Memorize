//
//  Theme.swift
//  Memorize
//
//  Created by Антон Сафронов on 08.10.2020.
//  Copyright © 2020 Антон Сафронов. All rights reserved.
//

import SwiftUI

struct Theme {
    var name: String = "Name"
    var color: Color = .white
    //MARK : в рандом пихнуть подсчёт элементов массива с эмоджи
    var numberOfPairs: Int = Int.random(in: 2...5)
    var arrayOfEmoji: Array<String>
}
