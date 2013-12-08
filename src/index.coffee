###
# The algorithm goes like so:
# 1. Create an array of squences.
#   1. Index 0 is the first column
#   2. Index 4 is the last column
#   3. Index 5 is the first row
#   4. Index 9 is the last row
#   5. Index 10 is the top-left to bottom-right diagonal
#   6. Index 11 is the top-right to bottom-left diagonal
# 2. Zero out the values at each sequence index. This represents how many 'numbers' in
#    this sequence have been seen
# 3. Build up a mapping of number -> [array of sequences this number is in]
#   1. The array can contain duplicates (for when there are multiples of the
#      same number in a sequence)
# 4. When a number is received
#   1. If that number is contained in the mapping
#     1. Loop through the mapped sequences and increment the value by 1 for each.
#     2. If the value is equal to 5, trigger 'win'
#   2. Remove that number from the mapping
###

BOARD_WIDTH = 5
BOARD_HEIGHT = 5
TL_BR_DIAGONAL_INDEX = BOARD_WIDTH + BOARD_HEIGHT
TR_BL_DIAGONAL_INDEX = BOARD_WIDTH + BOARD_HEIGHT + 1
SOCKET_SERVER = 'ws://yahoobingo.herokuapp.com'

io = require 'socket.io-client'
_ = require 'underscore'

client = io.connect SOCKET_SERVER

sequences = undefined # The possible bingo sequences
numbers = undefined # A mapping of my card numbers to an array of which possible 'bingo' sequences

client.on 'connect', ->
  console.log "Connected to ", SOCKET_SERVER

  client.emit 'register',
    name: "Jess Telford"
    email: "jess+yahoobingo@jes.st"
    url: "https://github.com/jesstelford/yahoo-bingo-node"

client.on 'card', (payload) ->
  console.log "Card received: ", payload

  sequences = (0 for i in [0..(BOARD_WIDTH + BOARD_HEIGHT + 1)])
  numbers = {}

  colIndex = 0
  _(payload.slots).each (columnOfNumbers, columnLetter) ->

    rowIndex = 0
    _(columnOfNumbers).each (number) ->
      numberKey = "#{columnLetter}#{number}"
      numbers[numberKey] ?= []
      numbers[numberKey].push colIndex
      numbers[numberKey].push BOARD_HEIGHT + rowIndex
      numbers[numberKey].push TL_BR_DIAGONAL_INDEX if colIndex is rowIndex # We're on the top-left to bottomr-right diagonal
      numbers[numberKey].push TR_BL_DIAGONAL_INDEX if colIndex + 1 is BOARD_WIDTH - rowIndex # We're on the top-left to bottomr-right diagonal
        
      rowIndex++

    colIndex++

client.on 'number', (number) ->
  hit = false
  _(numbers[number]).each (sequenceIndex) ->
    return unless sequences[sequenceIndex]?
    hit = true
    sequences[sequenceIndex]++
    if sequences[sequenceIndex] >= BOARD_WIDTH
      client.emit 'bingo' # WIN condition
      sequences[sequenceIndex] = undefined
  numbers[number] = undefined

  console.log "Number received: ", number, "... ", (if hit then "HIT" else "MISS")

client.on 'win', (message) ->
  console.log "WIN!", message

client.on 'lose', (message) ->
  console.log "LOSE!", message

client.on 'disconnect', ->
  console.log "Bye!"
  process.exit()
