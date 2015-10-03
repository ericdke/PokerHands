
struct Deck: CanTakeCard, SPHCardsDebug {

    let suits = ["♠","♣","♥","♦"]
    let ranks = ["A","K","Q","J","T","9","8","7","6","5","4","3","2"]

    var cards = [Card]()

    private let capacity = 52

    init() {
        for thisSuit in suits {
            for thisRank in ranks {
                cards.append(Card(suit: thisSuit, rank: thisRank))
            }
        }
    }

    mutating func shuffle() {
        cards.shuffleInPlace()
    }
    
    mutating func takeCards(number:Int) -> [Card] {
        guard self.count >= number else {
            return errorNotEnoughCards()
        }
        var c = [Card]()
        number.times {
            c.append(self.cards.takeOne())
        }
        return c
    }

    var count: Int { get { return cards.count } }

    var dealt: Int { get { return capacity - cards.count } }
}
