import Cocoa

class SPKSettings {
    static let sharedInstance = SPKSettings()
    
    var player1Card1Suit = ""
    var player1Card1Rank = ""
    var player1Card2Suit = ""
    var player1Card2Rank = ""
    var player1Random = false
    var player2Card1Suit = ""
    var player2Card1Rank = ""
    var player2Card2Suit = ""
    var player2Card2Rank = ""
    var player2Random = false
    
    var gameMode: GameMode = .random
    
    var player1Cards: [Card] {
        return player1Random ? [] : getPlayerCards(for: .player1)
    }
    
    var player2Cards: [Card] {
        return player2Random ? [] : getPlayerCards(for: .player2)
    }
    
    private func getPlayerCards(for type: PersonType) -> [Card] {
        switch type {
        case .player1:
            let card1 = Card(suit: getSuit(in: player1Card1Suit),
                             rank: getRank(in: player1Card1Rank))
            let card2 = Card(suit: getSuit(in: player1Card2Suit),
                             rank: getRank(in: player1Card2Rank))
            return [card1, card2]
        case .player2:
            let card1 = Card(suit: getSuit(in: player2Card1Suit),
                             rank: getRank(in: player2Card1Rank))
            let card2 = Card(suit: getSuit(in: player2Card2Suit),
                             rank: getRank(in: player2Card2Rank))
            return [card1, card2]
        default:
            return []
        }
    }
    
    private func getSuit(in label: String) -> String {
        // forced because label will be checked by the caller for not being empty
        return String(label.first!)
    }
    
    private func getRank(in rank: String) -> String {
        switch rank {
            case "Ace":
            return "A"
            case "King":
            return "K"
            case "Queen":
            return "Q"
            case "Jack":
            return "J"
            case "10":
            return "T"
            default:
            return rank
        }
    }
    
}
