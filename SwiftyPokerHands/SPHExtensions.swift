import Cocoa

func ==(lhs: Card, rhs: Card) -> Bool {
    if lhs.rank == rhs.rank && lhs.suit == rhs.suit {
        return true
    }
    return false
}

extension MutableCollectionType where Index == Int {
    
    mutating func shuffleInPlace() {
        if count < 2 { return }
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            swap(&self[i], &self[j])
        }
    }
    
}

protocol CanTakeCard {
    
    var cards: [Card] { get set }
    mutating func takeOneCard() -> Card?
    
}

extension CanTakeCard {
    
    mutating func takeOneCard() -> Card? {
        guard cards.count > 0 else { return nil }
        return cards.takeOne()
    }
    
}

protocol SPHCardsDebug {
    
    func errorNotEnoughCards() -> [Card]
    func error(message: String)
    
}

extension SPHCardsDebug {
    
    func errorNotEnoughCards() -> [Card] {
        error("not enough cards")
        return []
    }
    
    func error(message: String) {
        NSLog("ERROR: %@", message)
    }
    
}

extension SequenceType where Generator.Element == Card {
    
    var descriptions: [String] {
        return self.map { $0.description }
    }
    
    var spacedDescriptions: String {
        return self.descriptions.joinWithSeparator(" ")
    }
    
    func indexOf(card: Card) -> Int? {
        for (index, deckCard) in self.enumerate() {
            if deckCard == card {
                return index
            }
        }
        return nil
    }
    
    func joinNames(with string: String) -> String {
        return self.map({ $0.name }).joinWithSeparator(string)
    }
    
}

extension Range {
    
    var array: [Element] {
        return self.map { $0 }
    }
    
}

extension Int {
    
    func times(f: () -> ()) {
        if self > 0 {
            for _ in 0..<self {
                f()
            }
        }
    }
    
    func times(@autoclosure f: () -> ()) {
        if self > 0 {
            for _ in 0..<self {
                f()
            }
        }
    }
    
}

extension Array {
    
    mutating func takeOne() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        let item = self[index]
        self.removeAtIndex(index)
        return item
    }
    
    // adapted from ExSwift
    func permutation(length: Int) -> [[Element]] {
        if length < 0 || length > self.count {
            return []
        } else if length == 0 {
            return [[]]
        } else {
            var permutations: [[Element]] = []
            let combinations = combination(length)
            for combination in combinations {
                var endArray: [[Element]] = []
                var mutableCombination = combination
                permutations += self.permutationHelper(length, array: &mutableCombination, endArray: &endArray)
            }
            return permutations
        }
    }
    // adapted from ExSwift
    private func permutationHelper(n: Int, inout array: [Element], inout endArray: [[Element]]) -> [[Element]] {
        if n == 1 {
            endArray += [array]
        }
        for var i = 0; i < n; i++ {
            permutationHelper(n - 1, array: &array, endArray: &endArray)
            let j = n % 2 == 0 ? i : 0;
            let temp: Element = array[j]
            array[j] = array[n - 1]
            array[n - 1] = temp
        }
        return endArray
    }
    // adapted from ExSwift
    func combination(length: Int) -> [[Element]] {
        if length < 0 || length > self.count {
            return []
        }
        var indexes: [Int] = (0..<length).array
        var combinations: [[Element]] = []
        let offset = self.count - indexes.count
        while true {
            var combination: [Element] = []
            for index in indexes {
                combination.append(self[index])
            }
            combinations.append(combination)
            var i = indexes.count - 1
            while i >= 0 && indexes[i] == i + offset {
                i--
            }
            if i < 0 {
                break
            }
            i++
            let start = indexes[i-1] + 1
            for j in (i-1)..<indexes.count {
                indexes[j] = start + j - i + 1
            }
        }
        return combinations
    }

}
