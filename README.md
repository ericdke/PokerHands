![](https://img.shields.io/badge/Swift-4-green.svg?style=flat)

## Holdem Poker Hand Simulator

Mixing several techniques in Swift to evaluate a Holdem poker hand.

![Swifty Poker Hands](https://www.evernote.com/shard/s89/sh/3f391e4f-3ba4-45ee-b4f6-cdaa8a85628f/8c3ded92bfda886b/res/7971889e-0eab-4f56-971c-51731ef3274e/skitch.png)

## Techniques

- Compute a rank for each card

- Compute a rank for each possible 5 cards hand

- Permutations of all possible hands of 5 cards among the 7 cards in play

- Sort, filter, deduplicate the results

- Compare ranks by byte matching

- Reorder and extract results

## Demo app

A table view of a two-player hands simulator. Two players, with random or custom cards, go all-in each round.

## Credits

Original cards images are from [Playing Cards iOS Assets](https://github.com/hayeah/playing-cards-assets).

The 2-cards and 5-cards hand ranking algorithms are adapted from [swift-poker-hand-evaluator](https://github.com/s4nchez/swift-poker-hand-evaluator).

Some collection operations are adapted from [ExSwift](https://github.com/pNre/ExSwift).