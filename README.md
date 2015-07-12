## Holdem Poker Hand Simulator

Mixing several techniques in Swift to evaluate a Holdem poker hand.

*Uses Swift 2.0 and Xcode 7 beta 3+. Demo app needs OS X 10.10+.*

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

Original cards images: [Playing Cards iOS Assets](https://github.com/hayeah/playing-cards-assets)

2-cards and 5-cards hand ranking: [swift-poker-hand-evaluator](https://github.com/s4nchez/swift-poker-hand-evaluator)

Array permutations and combinations: [ExSwift](https://github.com/pNre/ExSwift) 

