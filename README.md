## Holdem Poker Hand Simulator

Mixing several techniques in Swift to evaluate a Holdem poker hand.

*Uses Swift 2.0 and Xcode 7 beta.*

![Swifty Poker Hands](https://www.evernote.com/shard/s89/sh/d97bc63e-6c45-48a5-bf70-6768b0fb6b8a/c70b3f8756cd858f/res/c07dd777-5e82-41f7-842d-25f27388e64e/skitch.png)

## Techniques

- Compute a rank for each card

- Compute a rank for each possible 5 cards hand

- Permutations of all possible hands of 5 cards among the 7 cards in play

- Sort, filter, deduplicate the results

- Compare ranks by byte matching

- Reorder and extract results

## Demo app

A simplistic table view of a two-player hands simulator.

## Credits

Original cards images: [Playing Cards iOS Assets](https://github.com/hayeah/playing-cards-assets)

2-cards and 5-cards hand ranking: [swift-poker-hand-evaluator](https://github.com/s4nchez/swift-poker-hand-evaluator)

Array permutations and combinations: [ExSwift](https://github.com/pNre/ExSwift) 

