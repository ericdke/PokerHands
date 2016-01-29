import Foundation

struct Player: CanTakeCard {

    init() {}

    init(name: String) {
        self.name = name
    }

    var name: String?

    var historyOfDealtHoldemCards = [(Card, Card, NSDate)]()
    
    var frequentHands = [String:Int]()

    var holdemHand: (HandRank, [String])?
    
    var holdemHandDescription: String? {
        return holdemHand?.1.joinWithSeparator(" ")
    }
    
    var holdemHandNameDescription: String? {
        return holdemHand?.0.name.rawValue.lowercaseString
    }

    var cardsHistory: String {
        let mapped = historyOfDealtHoldemCards.map { $0.0.description + " " + $0.1.description }
        return mapped.joinWithSeparator(", ")
    }

    var cards = [Card]() {
        didSet {
            let tu = (self.cards[0], self.cards[1], NSDate())
            historyOfDealtHoldemCards.append(tu)
            let fqname = "\(tu.0.description),\(tu.1.description)"
            if frequentHands[fqname] == nil {
                frequentHands[fqname] = 1
            } else {
                frequentHands[fqname]! += 1
            }
        }
    }

    var cardsNames: String { return cards.joinNames(with: ", ") }

    var count: Int { return cards.count }

    var holeCards: String { return cards.spacedDescriptions }
    
    var lastDealtHandReadableDate: String? {
        guard let date = historyOfDealtHoldemCards.last?.2 else { return nil }
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss:SSS"
        return formatter.stringFromDate(date)
    }
    
    var lastDealtHandDate: NSDate? {
        return historyOfDealtHoldemCards.last?.2
    }
}
