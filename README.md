## Holdem Poker Hand Simulator

Mixing several techniques in Swift to evaluate a Holdem poker hand.

*Version pre alpha, work in progress.*

![Swifty Poker Hands](https://www.evernote.com/shard/s89/sh/a0adda99-8b13-4fd2-9c00-14d542e21497/c3f58a528636a786/res/207bd881-cf62-4906-9af4-d6062aac9d0e/skitch.png)

## Techniques

- Compute a rank for each card

- Compute a rank for each possible 5 cards hand

- Permutations of all possible hands of 5 cards among the 7 cards in play

- Sort, filter, deduplicate the results

- Compare ranks by byte matching

- Reorder and extract results

## Demo app

A simplistic table view of a two-player hands simulator.