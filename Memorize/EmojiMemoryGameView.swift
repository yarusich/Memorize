//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Антон Сафронов on 16.07.2020.
//  Copyright © 2020 Антон Сафронов. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    // @ObservedObject ("наблюдаемый") - говорит, что внутри переменной есть
    // ObservableObject ("может быть наблюдаемым")
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            HStack {
                Text(EmojiMemoryGame.theme.name)
                Text("Score: \(viewModel.score)")
                
            } .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            
            Grid(viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    // вынести константу вниз
                    withAnimation(.linear(duration: 0.5)) {
                        viewModel.choose(card: card)
                    }
                }
                .padding(5)
            }
            .padding()
            .foregroundColor(EmojiMemoryGame.theme.color)
            
            Button(action: {
                withAnimation(.easeInOut) {
                    viewModel.restart()
                }
            }, label: {
                Text("New Game")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).foregroundColor(EmojiMemoryGame.theme.color)
            })
        }
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    @State private var animatedBonusRemaining: Double = 0
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaning
        withAnimation(.linear(duration: card.bonusTimeRemaning)) {
            animatedBonusRemaining = 0
        }
    }
    
    var body: some View {
        if card.isFaceUp || !card.isMatched {
            GeometryReader { geometry in
                ZStack {
                    Group {
                        if card.isConsumingBonusTime {
                            Pie(startAngle: Angle.degrees(0 - 90),
                                endAngle: Angle.degrees(-animatedBonusRemaining * 360 - 90),
                                clockwise: true)
                                .fill(EmojiMemoryGame.theme.color)
                                .onAppear() {
                                    startBonusTimeAnimation()
                                }
                        } else {
                            Pie(startAngle: Angle.degrees(0 - 90),
                                endAngle: Angle.degrees(-card.bonusRemaning * 360 - 90),
                                clockwise: true)
                        }
                    }
                    .padding(5)
                    .opacity(0.45)
                    
                    Text(card.content)
                        .font(Font.system(size: fontSize(for: geometry.size)))
                        .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                        .animation(
                            card.isMatched
                                ?
                                Animation.linear(duration: 1).repeatForever(autoreverses:false)
                                :
                                .default)
                }
                .cardify(isFaceUp: card.isFaceUp)
// MARK: - заставить работать эту анимацию
                .transition(AnyTransition.scale)
            }
            
            
        }
        
    }
    
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.7
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
//        game.choose(card: game.cards[0])
        return EmojiMemoryGameView(viewModel: game)
        
    }
}
