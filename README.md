[![CircleCI](https://circleci.com/gh/m13/minesweeper/tree/master.svg?style=svg)](https://circleci.com/gh/m13/minesweeper/tree/master)
[![Maintainability](https://api.codeclimate.com/v1/badges/7f047a96023e7481c897/maintainability)](https://codeclimate.com/github/m13/minesweeper/maintainability)


## Artifacts automatically saved by CircleCI

- [Coverage](https://27-197866707-gh.circle-artifacts.com/0/home/circleci/project/coverage/index.html#_AllFiles) - 100%
- [Documentation](https://27-197866707-gh.circle-artifacts.com/0/home/circleci/project/doc/table_of_contents.html#pages) - Just as example


## How to play

```bash
$ bundle install
$ irb
```
```ruby
irb(main):001:0> load './src/minesweeper.rb'
irb(main):002:0> game = Minesweeper.new(2, :easy)
irb(main):003:0> game.display
X X
X X
irb(main):004:0> game.status
Still playing
irb(main):005:0> game.attempt(1,1)
1
irb(main):006:0> game.attempt(1,2)
1
irb(main):006:0> game.attempt(2,1)
1
irb(main):007:0> game.display
1 1
1 X
irb(main):008:0> game.status
You won!
```

## Description

Code is split in 3 classes with very specific purposes:

1. `minesweeper.rb` is the contract and view. Only class that outputs (using `puts`) to the console.
2. `game.rb` is the controller. Handles the `status` logic and ratio for bombs. As simple as requirements.
3. `board` is the model. Saves the information and public methods to manipulate its data.

Considerations:

- Not a single file has more than 100 lines. 
- Gem are divided. Only one for validation typing is required.
- Developed using PRs. CI with tests were enabled from the start.
- Tests could be more complete. Even 100%, some are skipped.


## Stack

- [CircleCI](https://circleci.com/gh/m13/minesweeper): Continuous Integration and Delivery
- [Sorbet](https://sorbet.org/): Sorbet is a fast, powerful type checker designed for Ruby.
- [RuboCop](http://www.rubocop.org/en/stable/): Ruby static code analyzer (a.k.a. linter) and code formatter
- [Rspec](https://rspec.info/): Behaviour DrivenDevelopment for Ruby.
- [Rdoc](https://ruby.github.io/rdoc/): HTML and command-line documentation for Ruby projects
- [SimpleCov](https://github.com/colszowka/simplecov): 
Code coverage for Ruby 1.9+ with a powerful configuration library and automatic merging of coverage across test suites
- [Commitizen](https://commitizen.github.io/cz-cli/): Simple commit conventions for internet citizens.
