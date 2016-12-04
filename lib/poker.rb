# class to hold information about the value and suit of cards
class Card
  attr_accessor :value
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
  def to_s
    @value.to_s + @suit.to_s
  end
end

# class that holds information about hands
# initializes with an array of at least 5 cards
class Hand
  attr_reader :score
  def initialize(cards)
    @cards = []
    5.times do
      card = cards.shift
      @cards.push(Card.new(card[0], card[1]))
    end
    sort
    to_s
  end

  def to_s
    string = ''
    @cards.each { |card| string << card.to_s << ' '}
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
    # if ace is low, set the value of the ace to 1
    if ace_low?
      high_card.value = 1
      sort
    end
    1.upto(4) do |i|
      next_card = false
      # if the next card in order is found, set next_card to true
      @cards.each { |card| next_card = true if card.value == low_card.value + i }
      return false unless next_card
    end
    true
  end

  # not lazy
  def score_hand
    pairs = pair_evaluater
    return @score ||= 8 if straight? && flush?
    return @score ||= 7 if pairs == :four_of_a_kind
    return @score ||= 6 if pairs == :full_house
    return @score ||= 5 if flush?
    return @score ||= 4 if straight?
    return @score ||= 3 if pairs == :three_of_a_kind
    return @score ||= 2 if pairs == :two_pair
    return @score ||= 1 if pairs == :pair
    return @score ||= 0
  end

  # returns a sorted array of the value of cards with the quantity n
  # ex: if n is two returns a sorted array of all values that are pairs 
  def self.pairs_values(count, n)
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

  # determines if the hand has a type of pair
  def pair_evaluater
    # how many of each value is in the hand?
    count = value_counter
    # how many of each type of pair is in the hand?
    pairs = pair_counter(count)
    return :four_of_a_kind if pairs[:four] == 1
    return :full_house if pairs[:three] == 1 && pairs[:two] == 1
    return :three_of_a_kind if pairs[:three] == 1
    return :two_pair if pairs[:two] == 2
    return :pair if pairs[:two] == 1
    false
  end

  # determines which hand has the highest pair
  def self.compare_pairs(hand_one, hand_two, n, x = 0)
    return :win if self.pairs_values(hand_one.value_counter, n).last > self.pairs_values(hand_one.value_counter, n).last
    return :lose if self.pairs_values(hand_one.value_counter, n).last < self.pairs_values(hand_one.value_counter, n).last
    return :win if self.pairs_values(hand_one.value_counter, x).first > self.pairs_values(hand_one.value_counter, x).first
    return :lose if self.pairs_values(hand_one.value_counter, x).first < self.pairs_values(hand_one.value_counter, x).first
    :tie
  end

  # determines which hand has the  highest card
  def self.compare_high_card(hand_one, hand_two)
    return :win if hand_one.high_card.value > hand_two.high_card.value
    return :lose if hand_one.high_card.value < hand_two.high_card.value
    :tie
  end

  def self.compare(hand_one, hand_two)
    hand_one.score_hand
    hand_two.score_hand
    # return win if hand one has is better
    return :win if hand_one.score > hand_two.score
    # return lose if hand two is better
    return :lose if hand_one.score < hand_two.score
      # Resolve ties 
    case hand_one.score
    # both hands have a straight flush
    when 8 then return Hand.compare_high_card(hand_one, hand_two)
    # both hands have a four of a kind 
    when 7 then return Hand.compare_pairs(hand_one, hand_two, 4)
    # full house
    when 6 then return Hand.compare_pairs(hand_one, hand_two, 3, 2)
    # flush
    when 5 then return Hand.compare_high_card(hand_one, hand_two)
    # straight
    when 4 then return Hand.compare_high_card(hand_one, hand_two)
    # three of a kind
    when 3 then return Hand.compare_pairs(hand_one, hand_two, 3)
    # two pair
    when 2 then return Hand.compare_pairs(hand_one, hand_two, 2, 2)
    # pair
    when 1 then return Hand.compare_pairs(hand_one, hand_two, 2)
    # high card
    when 0 then return Hand.compare_high_card(hand_one, hand_two)
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
    outcome = Hand.compare(hand_one, hand_two)
    if outcome == :win
      p1 += 1
    elsif outcome == :lose
      p2 += 1
    else
      puts "tie on #{line.chomp}"
    end
  end
  puts p1, p2
  puts 'Press enter to quit'
  gets
end

run