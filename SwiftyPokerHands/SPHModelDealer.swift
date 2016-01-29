import Cocoa

struct Dealer: SPHCardsDebug {

    var evaluator: Evaluator

    var currentDeck: Deck

    var table: Table

    var verbose = false

    init() {
        currentDeck = Deck()
        table = Table()
        evaluator = Evaluator()
    }
    
    init(deck: Deck) {
        currentDeck = deck
        table = Table()
        evaluator = Evaluator()
    }
    
    init(evaluator: Evaluator) {
        currentDeck = Deck()
        table = Table()
        self.evaluator = evaluator
    }
    
    init(deck: Deck, evaluator: Evaluator) {
        currentDeck = deck
        table = Table()
        self.evaluator = evaluator
    }

    var currentGame: String { return table.currentGame }

    var flop: String { return table.flop }

    var turn: String { return table.turn }

    var river: String { return table.river }

    var currentHandWinner: Player? {
        didSet {
            if currentHandWinner != nil {
                if scores[currentHandWinner!.name!] == nil {
                    scores[currentHandWinner!.name!] = 1
                } else {
                    scores[currentHandWinner!.name!]! += 1
                }
            } else {
                scores = [:]
            }
        }
    }

    var scores = [String:Int]()

    mutating func changeDeck() {
        currentDeck = Deck()
    }

    mutating func shuffleDeck() {
        currentDeck.shuffle()
    }
    
    mutating func removeCards(inout player: Player) {
        player.cards = []
    }

    mutating func deal(numberOfCards: Int) -> [Card] {
        return currentDeck.takeCards(numberOfCards)
    }

    mutating func dealHoldemHand() -> [Card] {
        return deal(2)
    }

    mutating func dealHoldemHandTo(inout player: Player) {
        player.cards = dealHoldemHand()
    }
    
    mutating func dealHoldemCards(cards: [String]) -> [Card] {
        let upCardChars = cards.map({$0.uppercaseString.characters.map({String($0)})})
        var cardsToDeal = [Card]()
        for cardChars in upCardChars {
            let cardObj = Card(suit: cardChars[1], rank: cardChars[0])
            guard let indexToRemove = currentDeck.cards.indexOf(cardObj) else {
                NSLog("%@", "ERROR: \(cardObj) is not in the deck")
                break
            }
            currentDeck.cards.removeAtIndex(indexToRemove)
            cardsToDeal.append(cardObj)
        }
        return cardsToDeal
    }
    
    mutating func dealHoldemCardsTo(inout player: Player, cards: [String]) {
        player.cards = dealHoldemCards(cards)
    }
    
    mutating func dealHoldemCardsTo(inout player: Player, cards: [Card]) {
        var cardsToDeal = [Card]()
        for card in cards {
            guard let indexToRemove = currentDeck.cards.indexOf(card) else {
                NSLog("%@", "ERROR: \(card) is not in the deck")
                break
            }
            currentDeck.cards.removeAtIndex(indexToRemove)
            cardsToDeal.append(card)
        }
        player.cards = cardsToDeal
    }

    mutating func dealFlop() -> [Card] {
        table.dealtCards = []
        table.burnt = []
        let dealt = dealWithBurning(3)
        table.addCards(dealt)
        return dealt
    }

    mutating func dealTurn() -> [Card] {
        let dealt = dealWithBurning(1)
        table.addCards(dealt)
        return dealt
    }

    mutating func dealRiver() -> [Card] {
        return dealTurn()
    }

    private mutating func burn() -> Card? {
        return currentDeck.takeOneCard()
    }

    private mutating func dealWithBurning(numberOfCardsToDeal: Int) -> [Card] {
        guard let burned = burn() else { return errorNotEnoughCards() }
        table.addToBurntCards(burned)
        return deal(numberOfCardsToDeal)
    }

    mutating func evaluateHoldemHandAtRiverFor(inout player: Player) {
        player.holdemHand = evaluateHoldemHandAtRiver(player)
    }

    func evaluateHoldemHandAtRiver(player: Player) -> (HandRank, [String]) {
        let sevenCards = table.dealtCards + player.cards
        let cardsReps = sevenCards.map({ $0.description })
        // all 5 cards combinations from the 7 cards
        let perms = cardsReps.permutation(5)
        // TODO: do the permutations with rank/else instead of literal cards descriptions
        let sortedPerms = perms.map({ $0.sort(<) })
        let permsSet = NSSet(array: sortedPerms)
        let uniqs = Array(permsSet).map({ $0 as! [String] })
        var handsResult = [(HandRank, [String])]()
        for hand in uniqs {
            let h = evaluator.evaluate(hand)
            handsResult.append((h, hand))
        }
        handsResult.sortInPlace({ $0.0 < $1.0 })
        let bestHand = handsResult.first
        return bestHand!
    }

    mutating func updateHeadsUpWinner(player1 player1: Player, player2: Player) {
        currentHandWinner = findHeadsUpWinner(player1: player1, player2: player2)
    }

    func findHeadsUpWinner(player1 player1: Player, player2: Player) -> Player {
        if player1.holdemHand!.0 < player2.holdemHand!.0 {
            return player1 }
        else if player1.holdemHand!.0 == player2.holdemHand!.0 {
            return Player(name: "SPLIT") }
        else {
            return player2
        }
    }
}
