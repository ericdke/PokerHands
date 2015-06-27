//
//  CoreExtensions.swift
//  testPok
//
//  Created by ERIC DEJONCKHEERE on 27/06/2015.
//  Copyright (c) 2015 Eric Dejonckheere. All rights reserved.
//

import Cocoa

extension Range {
    func toArray () -> [T] {
        var result: [T] = []
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
            if !(find(shuffledIndex,newIndex) > -1 ) {
                shuffledIndex.append(newIndex)
            }
        }
        return  shuffledIndex
    }
}
extension Array {
    /**
    Returns all permutations of a given length within an array

    :param: length The length of each permutation
    :returns: All permutations of a given length within an array
    */
    func permutation (length: Int) -> [[T]] {
        var selfCopy = self
        if length < 0 || length > self.count {
            return []
        } else if length == 0 {
            return [[]]
        } else {
            var permutations: [[T]] = []
            let combinations = combination(length)
            for combination in combinations {
                var endArray: [[T]] = []
                var mutableCombination = combination
                permutations += self.permutationHelper(length, array: &mutableCombination, endArray: &endArray)
            }
            return permutations
        }
    }

    /**
    Recursive helper method where all of the permutation-generating work is done
    This is Heap's algorithm
    */
    private func permutationHelper(n: Int, inout array: [T], inout endArray: [[T]]) -> [[T]] {
        if n == 1 {
            endArray += [array]
        }
        for var i = 0; i < n; i++ {
            permutationHelper(n - 1, array: &array, endArray: &endArray)
            var j = n % 2 == 0 ? i : 0;
            //(array[j], array[n - 1]) = (array[n - 1], array[j])
            var temp: T = array[j]
            array[j] = array[n - 1]
            array[n - 1] = temp
        }
        return endArray
    }
    /**
    Returns all of the combinations in the array of the given length

    :param: length
    :returns: Combinations
    */
    func combination (length: Int) -> [[Element]] {
        if length < 0 || length > self.count {
            return []
        }
        var indexes: [Int] = (0..<length).toArray()
        var combinations: [[Element]] = []
        var offset = self.count - indexes.count
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
            var start = indexes[i-1] + 1
            for j in (i-1)..<indexes.count {
                indexes[j] = start + j - i + 1
            }
        }
        return combinations
    }
    func shuffle() -> [T] {
        var shuffledContent:[T] = []
        let shuffledIndex:[Int] = self.count.indexRandom()
        for i in 0...shuffledIndex.count-1 {
            shuffledContent.append(self[shuffledIndex[i]])
        }
        return shuffledContent
    }
    mutating func shuffled() {
        var shuffledContent:[T] = []
        let shuffledIndex:[Int] = self.count.indexRandom()
        for i in 0...shuffledIndex.count-1 {
            shuffledContent.append(self[shuffledIndex[i]])
        }
        self = shuffledContent
    }
    func chooseOne() -> T {
        return self[Int(arc4random_uniform(UInt32(self.count)))]
    }
    //TODO: make it an Optional
    mutating func takeOne() -> T {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        let item = self[index]
        self.removeAtIndex(index)
        return item
    }
    func choose(x:Int) -> [T] {
        var shuffledContent:[T] = []
        let shuffledIndex:[Int] = x.indexRandom()
        for i in 0...shuffledIndex.count-1 {
            shuffledContent.append(self[shuffledIndex[i]])
        }
        return shuffledContent }
}
