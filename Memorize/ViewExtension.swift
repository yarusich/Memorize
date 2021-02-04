//
//  File.swift
//  Memorize
//
//  Created by Антон Сафронов on 29.10.2020.
//  Copyright © 2020 Антон Сафронов. All rights reserved.
//

import SwiftUI

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
