require "poker"
describe Card do
  describe "attributes" do
    let(:ace_of_hearts) { Card.new('A', 'H') }
    it "has a #value of 14" do
      expect(ace_of_hearts.value).to eql(14)
    end
    it "has a #suit of 'H'" do
      expect(ace_of_hearts.suit).to eql('H')
    end
    let(:two_of_spades) { Card.new('2', 'S') }
  end
end

describe Hand do
  let(:high_card_hand)      { Hand.new(['3H', '6C', 'JS', 'TC', '8D']) }
  let(:pair_hand)           { Hand.new(['6H', 'AH', '6C', 'JS', '2H']) }
  let(:two_pair_hand)       { Hand.new([]) }
  let(:three_of_a_kind_hand){ Hand.new([]) }
  let(:straight_hand)       { Hand.new([]) }
  let(:flush_hand)          { Hand.new([]) }
  let(:full_house_hand)     { Hand.new([]) }
  let(:four_of_a_kind_hand) { Hand.new([]) }
  let(:straight_flush_hand) { Hand.new([]) }
  let(:pair_count)          { {6 => 2, 11 => 1, 14 => 1, 2 => 1} }
  describe "#low_card" do
    it "returns '3H'" do
      expect(high_card_hand.low_card.value).to eql(3)
      expect(high_card_hand.low_card.suit).to eql('H')
    end
    it "returns '2H'" do
      expect(pair_hand.low_card.value).to eql(2)
      expect(pair_hand.low_card.suit).to eql('H')
    end
  end

  describe "#high_card" do
    it "returns '11S'" do
      expect(high_card_hand.high_card.value).to eql(11)
      expect(high_card_hand.high_card.suit).to eql('S')
    end
    it "returns '14H'" do
      expect(pair_hand.high_card.value).to eql(14)
      expect(pair_hand.high_card.suit).to eql('H')
    end
  end

  describe "#sort" do; end

  describe "#ace_low?" do
    it "returns true when an ace and two are present" do
      expect(pair_hand.ace_low?).to be_true
    end
    it "returns false if either an ace or two aren't present" do
      expect(high_card_hand.ace_low?).to be_false
    end
  end

  describe "#flush?" do
    it "returns false when the hand isn't a flush" do
      expect(two_pair_hand.flush?).to be_false
    end
    it "returns true when the hand is a flush" do
      expect(flush_hand.flush?).to be_true
    end
  end
  describe "#straight?" do
    it "returns false when the hand isn't a straight" do
      expect(four_of_a_kind_hand.straight?).to be_false
    end
    it "returns true when the hand is a straight" do
      expect(straight_hand.striaght?).to be_true
    end
  end
  describe "#pairs_values" do
    it "searches a count-hash for values with quantity of n" do
      expect(pairs_values(pair_count, 2)).to eql([6])
    end
  end
  describe "#score_hand" do; end
  describe "#value_counter" do; end
  describe "#pair_counter" do; end
  describe "#pair_evaluater" do; end
  describe "#compare" do; end
end
