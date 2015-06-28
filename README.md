## Holdem Poker Hand Simulator

Mixing several techniques in Swift to evaluate a Holdem poker hand.

*Version pre alpha, work in progress.*

![Swifty Poker Hands](https://www.evernote.com/shard/s89/sh/ba9bd648-4f4b-411e-a364-faf8f36bcd69/3d9d3205fc464db2/res/414d71b4-06e7-47bd-8795-5a8a3be2b2c5/skitch.png)

## Techniques

- Compute a rank for each card

- Compute a rank for each possible 5 cards hand

- Permutations of all possible hands of 5 cards among the 7 cards in play

- Sort, filter, deduplicate the results

- Compare ranks by byte matching

- Reorder and extract results

## Demo app

A simplistic table view of a two-player hands simulator.