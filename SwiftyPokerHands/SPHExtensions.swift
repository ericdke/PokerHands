import Cocoa

//extension CollectionType where Index == Int {
//    /// Return a copy of `self` with its elements shuffled
//    func shuffle() -> [Generator.Element] {
//        var list = Array(self)
//        list.shuffleInPlace()
//        return list
//    }
//}
//
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

func ==(lhs: Card, rhs: Card) -> Bool {
    if lhs.rank == rhs.rank && lhs.suit == rhs.suit {
        return true
    }
    return false
}

extension Range {
    func toArray () -> [Element] {
        var result: [Element] = []
        for i in self {
            result.append(i)
        }
        return result
    }
}

extension Int {
    func random() -> Int {
        return Int(arc4random_uniform(UInt32(abs(self))))
    }
    func indexRandom() -> [Int] {
        var newIndex = 0
        var shuffledIndex:[Int] = []
        while shuffledIndex.count < self {
            newIndex = Int(arc4random_uniform(UInt32(self)))
            if !(shuffledIndex.indexOf(newIndex) > -1 ) {
                shuffledIndex.append(newIndex)
            }
        }
        return  shuffledIndex
    }
}

extension Array {
    func chooseOne() -> Element {
        return self[Int(arc4random_uniform(UInt32(self.count)))]
    }
    
    //TODO: make it an Optional
    mutating func takeOne() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        let item = self[index]
        self.removeAtIndex(index)
        return item
    }
    
    // adapted from ExSwift
    func permutation (length: Int) -> [[Element]] {
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
    func combination (length: Int) -> [[Element]] {
        if length < 0 || length > self.count {
            return []
        }
        var indexes: [Int] = (0..<length).toArray()
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
    func choose(x:Int) -> [Element] {
        var shuffledContent:[Element] = []
        let shuffledIndex:[Int] = x.indexRandom()
        for i in 0...shuffledIndex.count-1 {
            shuffledContent.append(self[shuffledIndex[i]])
        }
        return shuffledContent }
}
