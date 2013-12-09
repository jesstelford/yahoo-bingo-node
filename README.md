# Yahoo! Bingo Node project

Playing Bingo with Node and Yahoo! to win me some prizes.

## Setup

```bash
$ git clone https://github.com/jesstelford/yahoo-bingo-node.git
$ cd yahoo-bingo-node
$ npm install
$ make
```

## Usage

```bash
$ node lib/index.js
```

## About

### Motivation

During Node Summit SF 2013
([#NodeSummit](https://twitter.com/search?q=%23nodesummit)), Yahoo! promoted a
competition to win some prizes by interacting with their node server via web
sockets. [More info](https://yahoobingo.herokuapp.com).

### How

This project is built using:

 * node.js 0.10.x
 * socket.io-client
 * CoffeeScript Redux
 * Underscore JS

Originally forked from [Michael Ficarra](https://github.com/michaelficarra)'s [coffeescript-project](https://github.com/michaelficarra/coffeescript-project), with
additional help from [Jess Telford](https://github.com/jesstelford)'s [coffee-boilerplate](https://github.com/jesstelford/coffee-boilerplate).

## License

FreeBSD. See [`LICENSE`](LICENSE) for more details.
