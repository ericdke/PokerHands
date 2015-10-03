struct Table {

    var dealtCards = [Card]()

    var burnt = [Card]()

    var burntCards: String {
        get {
            guard dealtCards.count > 0 else { return "" }
            return "\nBurnt cards: \(burnt.spacedDescriptions)"
        }
    }

    var currentGame: String { get { return dealtCards.spacedDescriptions } }

    var flop: String {
        get {
            guard dealtCards.count > 2 else { return "" }
            return dealtCards[0...2].spacedDescriptions
        }
    }

    var turn: String {
        get {
            guard dealtCards.count > 3 else { return "" }
            return dealtCards[3].description
        }
    }

    var river: String {
        get {
            guard dealtCards.count > 4 else { return "" }
            return dealtCards[4].description
        }
    }

    mutating func addCards(cards: [Card]) {
        dealtCards += cards
    }

    mutating func addToBurntCards(card: Card) {
        burnt.append(card)
    }

}

