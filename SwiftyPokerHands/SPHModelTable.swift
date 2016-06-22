public struct Table {

    var dealtCards = [Card]()

    var burnt = [Card]()

    var currentGame: String {
        return dealtCards.spacedDescriptions
    }

    var flop: String {
        guard dealtCards.count > 2 else { return "" }
        return dealtCards[0...2].spacedDescriptions
    }

    var turn: String {
        guard dealtCards.count > 3 else { return "" }
        return dealtCards[3].description
    }

    var river: String {
        guard dealtCards.count > 4 else { return "" }
        return dealtCards[4].description
    }

    mutating func add(cards: [Card]) {
        dealtCards += cards
    }

    mutating func addToBurnt(card: Card) {
        burnt.append(card)
    }

}

