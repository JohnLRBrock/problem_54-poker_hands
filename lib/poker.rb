# class to hold information about the value and suit of cards
class Card
  attr_reader :value
  attr_reader :suit
  def initialize(value, suit)
    @value = 
      case value
      when "T" then 10
      when "J" then 11
      when "Q" then 12
      when "K" then 13
      when "A" then 14
      else value.to_i
      end
    @suit = suit
  end
end

# class that holds information about hands
# initializes with an array of cards
class Hand
  def initialize(cards)
    @cards = []
    @score = []
    5.times do
      card = cards.shift
      @cards.push(Card.new(card[0], card[1]))
    end
    sort
  end

  def to_s
    string = ''
    @cards.each { |card| string << card.value << card.suit << ' '}
    string
  end
  # returns the card with the lowest value in the hand
  def low_card
    @cards.first
  end
  def high_card
    @cards.last
  end
  def sort
    @cards.sort! { |card1, card2|card1.value <=> card2.value }
  end
  # returns true if a hand has an ace and a two
  def ace_low?
    return true if high_card.value == 14 && low_card.value == 2
    return false
  end

 # returns true if hand is flush
  def flush?
    bool = true
    @cards.each { |card| bool = false unless @cards[0].suit == card.suit }
    bool
  end
  # returns true if hand is straight
  def straight?
    if ace_low?
      low = 1
    else
      low = low_card
    end
    i = 1
    4.times do
      # next_card set to true if the next card in straight is found
      next_card = false
      @cards.each do |card|
        if card.value == low.value + i
          i += 1
          next_card = true
        end
      end
      return false unless next_card
      # reset next_card to search for the next card
      next_card = false
    end
    # no false is returned so the hand must be straight

    # if ace is low, set the value of the ace to 1

  end

  # not lazy
  def score_hand
    pairs = pair_evaluater
    @score ||= 8 if straight? && flush?
    @score ||= 7 if pairs == :four_of_a_kind
    @score ||= 6 if pairs == :full_house
    @score ||= 5 if flush?
    @score ||= 4 if straight?
    @score ||= 3 if pairs == :three_of_a_kind
    @score ||= 2 if pairs == :two_pair
    @score ||= 1 if pairs == :pair
    @score ||= 0
  end

  # returns a sorted array of the value of cards with the quantity n
  # ex: if n is two returns a sorted array of all values that are pairs 
  def pairs_values(count, n)
    output = []
    count.each do |card_value, multiples|
      output.push(card_value) if multiples == n
    end
    output.sort
  end
  # how many of each value are in the hand?
  def value_counter
    count = Hash.new(0)
    @cards.each{ |card| count[card.value] += 1}
    count
  end
  # how many of each type of pair are in the hand
  def pair_counter(count)
    pairs = Hash.new(0)
    count.each do |card_value, count|
      if count == 1
        next
      elsif count == 2
        pairs[:two] += 1
      elsif count == 3
        pairs[:three] += 1
      elsif count == 4
        pairs[:four] += 1
      end
    end
    pairs
  end

  # returns array with 
  def pair_evaluater
    # how many of each value is in the hand?
    count = value_counter
    # how many of each type of pair is in the hand?
    pairs = pair_counter
    return :four_of_a_kind if pairs[:four] == 1
    return :full_house if pairs[:three] == 1 && pairs[:two] == 1
    return :three_of_a_kind if pairs[:three]
    return :two_pair if pairs[:two] == 2
    return :pair if pairs[:two] == 1
    false
  end

  # DRY this method
  # rewrite to take hands instead of one as variables
  # rewrite to only check high cards in case of tie
  def compare(hand)
  score1, score2 = score, hand.score
  return :win if score1[0] > score2[0]
  return :lose if score1[0] < score2[0]
    case score1
    when 8
      if score1[1] > score2[1]
        return :win
      elsif score1[1] < score2[1]
        return :lose
      else 
        return :tie
      end
    when 7
      if score1[1] > score2[1]
        return :win
      else
        return :lose
      end
    when 6
      if score1[1] > score2[1]
        return :win
      elsif score1[1] < score2[1]
        return :lose
      elsif score1[2] > score2[2]
        return :win
      elsif score1[2] < score2[2]
        return :lose
      else
        return :tie
      end
    when 5
      if score1[1] > score2[1]
        return :win
      elsif score1[1] < score2[1]
        return :lose
      else 
        return :tie
      end
    when 4
      if score1[1] > score2[1]
        return :win
      elsif score1[1] < score2[1]
        return :lose
      else 
        return :tie
      end
    when 3
      if score1[1] > score2[1]
        return :win
      elsif score1[1] < score2[1]
        return :lose
      else 
        return :tie
      end
    when 2
      if score1[1] > score2[1]
        return :win
      elsif score1[1] < score2[1]
        return :lose
      elsif score1[2] > score2[2]
        return :win
      elsif score1[2] < score2[2]
        return :lose
      else 
        return :tie
      end
    when 1
      if score1[1] > score2[1]
        return :win
      elsif score1[1] < score2[1]
        return :lose
      else
        return :tie
      end
    when 0
      1.upto(5) do |i|
        if score1[i].value > score2[i].value
          return :win
        elsif score1[i].value < score2[i].value
          return :lose
        end
      end
      return :tie
    end
  end
end
def run
  p1 = 0
  p2 = 0
  # each line of the file is a pair of hands
  hands = File.readlines('p054_poker.txt')
  hands.each do |line|
    # split the line into an array of ten cards
    hands = line.strip.split
    hand_one = Hand.new(hands)
    hand_two = Hand.new(hands)
    puts hand_one
    puts hand_two
    outcome = compare(hand_one, hand_two)
    if outcome == :win
      p1 += 1
      puts "Hand one wins"
    elsif outcome == :lose
      p2 += 1
      puts "Hand two wins"
    else
      puts "tie on #{line.chomp}"
    end
  end
  puts p1, p2
  puts 'Press enter to quit'
  gets
end

