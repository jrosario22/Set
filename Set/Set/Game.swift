//
//  Game.swift
//  Set
//
//  Created by Jeson Rosario on 10/14/19.
//  Copyright © 2019 Jeson Rosario. All rights reserved.
//

import Foundation

class Game {
    
    var cards = [Card]()
    var visibleCards = [Card]()
    var score = 0
    var checkSetCondition = 0
    var selectedCards = [Card]()
    var setCardDeck = [Card]()
    
    // Assignment for checking set
    var cardOne = 0
    var cardTwo = 1
    var cardThree = 2
    var times = 0
    
    func chooseCard (at index: Int) {
        let chosenCard = cards[index]
        if !(selectedCards.contains { $0 == chosenCard }) {
            if selectedCards.count == 3 {
                selectedCards.removeAll()
            }
            selectedCards.append(chosenCard)
            if selectedCards.count == 3 {
                checkSetCondition = 0
                let firstCard = selectedCards[0]
                let secondCard = selectedCards[1]
                let thirdCard = selectedCards[2]
                for compareIndex in 0...3 {
                    if !(firstCard.condition[compareIndex] == secondCard.condition[compareIndex] && secondCard.condition[compareIndex] == thirdCard.condition[compareIndex]), !(firstCard.condition[compareIndex] != secondCard.condition[compareIndex] && secondCard.condition[compareIndex] != thirdCard.condition[compareIndex] && firstCard.condition[compareIndex] != thirdCard.condition[compareIndex]) {
                        score -= 15
                        break
                    } else {
                        checkSetCondition += 1
                    }
                }
                
                if checkSetCondition == 4 {
                    setCardDeck += [firstCard, secondCard, thirdCard]
                    checkSetCondition = 0
                    visibleCards = visibleCards.filter { $0 != firstCard }
                    visibleCards = visibleCards.filter { $0 != secondCard }
                    visibleCards = visibleCards.filter { $0 != thirdCard }
                    score += 30
                }
            }
        } else {
            selectedCards = selectedCards.filter { $0 != chosenCard }
        }
    }
    
    func penalize() {
        if !setCardDeck.isEmpty {
            score -= 15
        }
    }
    
    func removeSetCardCondition() {
        for index in cards.indices {
            if setCardDeck.contains(where: { $0 == cards[index] }) {
                visibleCards = visibleCards.filter { $0 != cards[index]}
                cards[index].condition.removeAll()
            }
        }
    }
    
    func checkForSet() {
        while cardOne < visibleCards.count - 2 {
            while cardTwo < visibleCards.count - 1 {
                while cardThree < visibleCards.count {
                    let firstCard = visibleCards[cardOne]
                    let secondCard = visibleCards[cardTwo]
                    let thirdCard = visibleCards[cardThree]
                    for matchingIndex in 0...3 {
                        times += 1
                        if !(firstCard.condition[matchingIndex] == secondCard.condition[matchingIndex] && secondCard.condition[matchingIndex] == thirdCard.condition[matchingIndex]), !(firstCard.condition[matchingIndex] != secondCard.condition[matchingIndex] && secondCard.condition[matchingIndex] != thirdCard.condition[matchingIndex] && firstCard.condition[matchingIndex] != thirdCard.condition[matchingIndex]) {
                            break
                        } else {
                            checkSetCondition += 1
                        }
                    }
                   
                    if checkSetCondition == 4 {
                        setCardDeck += [firstCard, secondCard, thirdCard]
                        cardOne = 0
                        cardTwo = 1
                        cardThree = 2
                        times = 0
                        checkSetCondition = 0
                        return
                    }
                    checkSetCondition = 0
                    cardThree += 1
                }
                cardTwo += 1
                cardThree = cardTwo + 1
            }
            cardOne += 1
            cardTwo = cardOne + 1
            cardThree = cardTwo + 1
        }
        cardOne = 0
        cardTwo = 1
        cardThree = 2
        times = 0
    }
    
    init(numberOfCards: Int) {
        for _ in 1...numberOfCards {
            let card = Card()
            cards += [card]
        }
    }
}

extension Card: Equatable {
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.condition == rhs.condition
    }
}
