struct Table {

    var dealtCards = [Card]()

    var burnt = [Card]()

    var burntCards: String { get {
        if burnt.count > 0 {
            let b = " ".join(cardsDescriptions(burnt))
            return "\nBurnt cards: \(b)" }
        return ""
        }
    }

    var currentGame: String { get {
        if dealtCards.count > 0 {
            return " ".join(cardsDescriptions(dealtCards)) }
        return ""
        }
    }

    var flop: String { get {
        if dealtCards.count > 2 {
            return " ".join(cardsDescriptions(dealtCards)[0...2]) }
        return ""
        }
    }

    var turn: String { get {
        if dealtCards.count > 3 {
            return dealtCards[3].description }
        return ""
        }
    }

    var river: String { get {
        if dealtCards.count > 4 {
            return dealtCards[4].description }
        return ""
        }
    }

    mutating func addCards(cards: [Card]) {
        dealtCards += cards
    }

    mutating func addToBurntCards(card: Card) {
        burnt.append(card)
    }

    private func cardsDescriptions(cards: [Card]) -> [String] {
        return cards.map({ $0.description })
    }
}

