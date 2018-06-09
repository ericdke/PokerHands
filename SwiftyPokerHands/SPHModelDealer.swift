import Cocoa

public struct Dealer: SPHCardsDebug {

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
    
    mutating func removeCards(from player: inout Player) {
        player.cards = []
    }

    mutating func deal(number: Int) -> [Card] {
        return currentDeck.takeCards(number: number)
    }

    mutating func dealHand() -> [Card] {
        return deal(number: 2)
    }

    mutating func dealHand(to player: inout Player) {
        player.cards = dealHand()
    }
    
    mutating func deal(cards: [String]) -> [Card] {
        let upCardChars = cards.map({$0.uppercased().map({String($0)})})
        var cardsToDeal = [Card]()
        for cardChars in upCardChars {
            let cardObj = Card(suit: cardChars[1], rank: cardChars[0])
            guard let index = currentDeck.cards.index(of: cardObj) else {
                NSLog("%@", "ERROR: \(cardObj) is not in the deck")
                break
            }
            currentDeck.cards.remove(at: index)
            cardsToDeal.append(cardObj)
        }
        return cardsToDeal
    }
    
    mutating func deal(cards: [String], to player: inout Player) {
        player.cards = deal(cards: cards)
    }
    
    mutating func deal(cards: [Card], to player: inout Player) {
        var cardsToDeal = [Card]()
        for card in cards {
            guard let indexToRemove = currentDeck.cards.index(of: card) else {
                NSLog("%@", "ERROR: \(card) is not in the deck")
                break
            }
            currentDeck.cards.remove(at: indexToRemove)
            cardsToDeal.append(card)
        }
        player.cards = cardsToDeal
    }

    @discardableResult mutating func dealFlop() -> [Card] {
        table.dealtCards = []
        table.burnt = []
        let dealt = dealWithBurning(number: 3)
        table.add(cards: dealt)
        return dealt
    }

    @discardableResult mutating func dealTurn() -> [Card] {
        let dealt = dealWithBurning(number: 1)
        table.add(cards: dealt)
        return dealt
    }

    @discardableResult mutating func dealRiver() -> [Card] {
        return dealTurn()
    }

    private mutating func burn() -> Card? {
        return currentDeck.takeOneCard()
    }

    private mutating func dealWithBurning(number: Int) -> [Card] {
        guard let burned = burn() else {
            return errorNotEnoughCards()
        }
        table.addToBurnt(card: burned)
        return deal(number: number)
    }

    mutating func evaluateHandAtRiver(for player: inout Player) {
        player.hand = evaluateHandAtRiver(player: player)
    }

    func evaluateHandAtRiver(player: Player) -> (HandRank, [String]) {
        let sevenCards = table.dealtCards + player.cards
        let cardsReps = sevenCards.map({ $0.description })
        // all 5 cards combinations from the 7 cards
        let perms = cardsReps.permutation(5)
        // TODO: do the permutations with rank/else instead of literal cards descriptions
        let sortedPerms = perms.map({ $0.sorted(by: <) })
        let permsSet = NSSet(array: sortedPerms)
        let uniqs = Array(permsSet).map({ $0 as! [String] })
        var handsResult = [(HandRank, [String])]()
        for hand in uniqs {
            let h = evaluator.evaluate(cards: hand)
            handsResult.append(
                (h, hand)
            )
        }
        handsResult.sort(by: { $0.0 < $1.0 })
        let bestHand = handsResult.first
        return bestHand!
    }

    mutating func updateHeadsUpWinner(player1: Player, player2: Player) {
        currentHandWinner = findHeadsUpWinner(player1: player1, player2: player2)
    }

    func findHeadsUpWinner(player1: Player, player2: Player) -> Player {
        if player1.hand!.0 < player2.hand!.0 {
            return player1 }
        else if player1.hand!.0 == player2.hand!.0 {
            return Player(name: "SPLIT") }
        else {
            return player2
        }
    }
}
