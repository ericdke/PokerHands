See the new version at https://github.com/ericdke/PokerHands2

---


![](https://img.shields.io/badge/Swift-4.2-green.svg?style=flat)

## Holdem Poker Hand Simulator

Mixing several techniques in Swift to evaluate a Holdem poker hand.

![Swifty Poker Hands](https://monosnap.com/file/cvebqCKISBpZDNwpN6cKarT6QDmx6S.png)

## Techniques

- Compute a rank for each card

- Compute a rank for each possible 5 cards hand

- Permutations of all possible hands of 5 cards among the 7 cards in play

- Sort, filter, deduplicate the results

- Compare ranks by byte matching

- Reorder and extract results

## Demo app

A table view of a two-player hands simulator. Two players, with random or custom cards, go all-in each round.

There's a binary in the Resources folder.

## Credits

Original cards images are from [Playing Cards iOS Assets](https://github.com/hayeah/playing-cards-assets).

The 2-cards and 5-cards hand ranking algorithms are adapted from [swift-poker-hand-evaluator](https://github.com/s4nchez/swift-poker-hand-evaluator).

Some collection operations are adapted from [ExSwift](https://github.com/pNre/ExSwift).
