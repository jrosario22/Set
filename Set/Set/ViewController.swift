//
//  ViewController.swift
//  Set
//
//  Created by Jeson Rosario on 9/25/19.
//  Copyright © 2019 Jeson Rosario. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var game = Game(numberOfCards: cardButtons.count)
    
    @IBOutlet var cardButtons: [UIButton]! {
        didSet{
            assignProperty()
        }
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            if cardNumber < visibleCards, !game.cards[cardNumber].condition.isEmpty {
                assignProperty()
                game.chooseCard(at: cardNumber)
                updateViewFromModel()
                game.removeSetCardCondition()
            }
        }
    }
    
    @IBAction func newGameButton(_ sender: UIButton) {
        reset()
    }
    
    @IBAction func hintButton(_ sender: UIButton) {
        game.checkForSet()
        updateViewFromModel()
        game.setCardDeck.removeAll()
    }
    
    
    @IBAction func addCardButton(_ sender: UIButton) {
        addCards()
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    var visibleCards = 12
    
    var cardDeck = Card().cardDeck
    
    func assignProperty() {
        for index in cardButtons.indices {
            if game.cards[index].condition.isEmpty, index < visibleCards, cardDeck.count > 0 {
                let button = cardButtons[index]
                let randomPropertyIndex = cardDeck.count.arc4random
                let cardProperty = cardDeck.remove(at: randomPropertyIndex)
                let cardSymbol = cardProperty.0,
                numberOfSymbol = String(cardProperty.0.count),
                cardSymbolColor = cardProperty.1,
                cardSymbolStyle = cardProperty.2
                
                var symbolColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
                switch cardSymbolColor {
                case "blue": symbolColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
                case "green": symbolColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                case "red": symbolColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                default: return
                }
                
                if cardSymbolStyle == "filled" { button.setAttributedTitle(NSAttributedString(string: cardSymbol, attributes: [NSAttributedString.Key.foregroundColor: symbolColor]), for: UIControl.State.normal)
                } else if cardSymbolStyle == "shade" {
                    button.setAttributedTitle(NSAttributedString(string: cardSymbol, attributes: [NSAttributedString.Key.foregroundColor: UIColor.withAlphaComponent(symbolColor)(0.25)]), for: UIControl.State.normal)
                } else if cardSymbolStyle == "outline" {
                    button.setAttributedTitle(NSAttributedString(string: cardSymbol, attributes: [NSAttributedString.Key.strokeColor: symbolColor,NSAttributedString.Key.strokeWidth: 10]), for: UIControl.State.normal)
                }
                
                let symbol = String(cardSymbol[cardSymbol.startIndex])
                game.cards[index].condition = [symbol, numberOfSymbol, cardSymbolColor, cardSymbolStyle]
                game.visibleCards.append(game.cards[index])
            } else if game.cards[index].condition.isEmpty, cardDeck.count < 1 {
                
                cardButtons[index].backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
                cardButtons[index].setAttributedTitle(NSAttributedString(string: ""), for: UIControl.State.normal)
            }
        }
        
    }
    
    func addCards() {
        for index in cardButtons.indices {
            if game.cards[index].condition.isEmpty, index < visibleCards {
                assignProperty()
                updateViewFromModel()
                return
            }
        }
        
        if visibleCards < 24 {
            for _ in 0..<3 {
                cardButtons[visibleCards].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                visibleCards += 1
            }
            assignProperty()
            updateViewFromModel()
            game.removeSetCardCondition()
        }
    }
    
    func endGame() {
        for index in cardButtons.indices {
            game.cards[index].condition.removeAll()
            cardButtons[index].layer.borderWidth = 0.0
            cardButtons[index].setAttributedTitle(NSAttributedString(string: ""), for: UIControl.State.normal)
            cardButtons[index].backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        }
    }

    
    func reset() {
        visibleCards = 12
        game.score = 0
        game.selectedCards.removeAll()
        game.setCardDeck.removeAll()
        game.visibleCards.removeAll()
        cardDeck = Card().cardDeck
        for index in cardButtons.indices {
            game.cards[index].condition.removeAll()
            cardButtons[index].setAttributedTitle(NSAttributedString(string: ""), for: UIControl.State.normal)
        }
        assignProperty()
        updateViewFromModel()
    }
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            button.backgroundColor = index < visibleCards ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            if game.setCardDeck.contains(where: { $0 == card }) {
                button.layer.borderWidth = 6.0
                button.layer.borderColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
                button.layer.cornerRadius = 8.0
            } else if game.selectedCards.contains(where: { $0 == card }) {
                button.layer.borderWidth = 5.0
                button.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                button.layer.cornerRadius = 8.0
            } else {
                button.layer.borderWidth = 0.0
            }
        }
        scoreLabel.text = "Score: \(game.score)"
    }
    
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0{
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
