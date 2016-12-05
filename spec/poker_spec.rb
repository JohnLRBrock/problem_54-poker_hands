require 'poker'
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
  let(:pair_hand_2)         { Hand.new(['5C', '8H', 'TH', 'TC', 'QS']) }
  let(:pair_hand_3)         { Hand.new(['4D', '9H', 'JC', 'JS', 'KS']) }
  let(:two_pair_hand)       { Hand.new(['KD', 'KC', 'QH', 'QS', 'JD']) }
  let(:three_of_a_kind_hand){ Hand.new(['AC', 'AH', 'AS', '8D', '7C']) }
  let(:straight_hand)       { Hand.new(['5H', '6C', '7D', '8S', '9H']) }
  let(:flush_hand)          { Hand.new(['2H', '4H', '6H', '8H', 'KH']) }
  let(:full_house_hand)     { Hand.new(['AS', 'AD', 'AC', 'KH', 'KS']) }
  let(:four_of_a_kind_hand) { Hand.new(['AH', 'AC', 'AD', 'AS', '2H']) }
  let(:straight_flush_hand) { Hand.new(['5S', '6S', '7S', '8S', '9S']) }
  let(:pair_count)          { {6 => 2, 11 => 1, 14 => 1, 2 => 1} }
  let(:two_pair_count)      { {11 => 1, 12 => 2, 13 => 2} }
  let(:pair_count_2)        { {10 => 2, 5 => 1, 8 => 1, 12 => 1} }
  let(:pair_count_3)        { {11 => 2, 4 => 1, 9 => 1, 13 => 1} }
  
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

  describe "#ace_low?" do
    it "returns true when an ace and two are present" do
      expect(pair_hand.ace_low?).to be(true)
    end
    it "returns false if either an ace or two aren't present" do
      expect(high_card_hand.ace_low?).to be(false)
    end
  end

  describe "#flush?" do
    it "returns false when the hand isn't a flush" do
      expect(two_pair_hand.flush?).to be(false)
    end
    it "returns true when the hand is a flush" do
      expect(flush_hand.flush?).to be(true)
    end
  end

  describe "#straight?" do
    it "returns false when the hand isn't a straight" do
      expect(four_of_a_kind_hand.straight?).to be(false)
    end
    it "returns true when the hand is a straight" do
      expect(straight_hand.straight?).to be(true)
    end
  end

  describe "#value_counter" do
    context "pair_hand_2" do
      it "returns {10 => 2, 5 => 1, 8 => 1, 12 => 1}" do
        expect(pair_hand_2.value_counter).to eql(pair_count_2)
      end
    end
  end

  describe ".pairs_values" do
    it "searches a count-hash for values with quantity of n" do
      expect(Hand.pairs_values(pair_count, 2)).to eql([6])
    end
  end

  describe "#score_hand" do
    context "high_card_hand" do
      it "sets @score to 0" do
        high_card_hand.score_hand
        expect(high_card_hand.score).to eql(0)
      end
    end
    context "pair_hand" do
      it "sets @score to 1" do
       pair_hand.score_hand
       expect(pair_hand.score).to eql(1)
     end
    end
    context "two_pair_hand" do
      it "sets @score to 2" do
        two_pair_hand.score_hand
        expect(two_pair_hand.score).to eql(2)
      end
    end
    context "three_pair_hand" do
      it "sets @score to 3" do
        three_of_a_kind_hand.score_hand
        expect(three_of_a_kind_hand.score).to eql(3)
      end
    end
    context "straight_hand" do
      it "sets @score to 4" do
        straight_hand.score_hand
        expect(straight_hand.score).to eql(4)
      end
    end
    context "flush_hand" do
      it "sets @score to 5" do
        flush_hand.score_hand
        expect(flush_hand.score).to eql(5)
      end
    end
    context "full_house_hand" do
      it "sets @score to 6" do
        full_house_hand.score_hand
        expect(full_house_hand.score).to eql(6)
      end
    end
    context "four_of_a_kind_hand" do
      it "sets @score to 7" do
        four_of_a_kind_hand.score_hand
        expect(four_of_a_kind_hand.score).to eql(7)
      end
    end
    context "straight_flush_hand" do
      it "sets @score to 8" do
        straight_flush_hand.score_hand
        expect(straight_flush_hand.score).to eql(8)
      end
    end
  end

  describe "#pair_evaluater" do
    context "high_card_hand" do
      it "returns" do
        expect(high_card_hand.pair_evaluater).to eql(false)
      end
    end
    context "pair_hand" do
      it "returns" do
        expect(pair_hand.pair_evaluater).to eql(:pair)
      end
    end
    context "two_pair_hand" do
      it "returns" do
        expect(two_pair_hand.pair_evaluater).to eql(:two_pair)
      end
    end
    context "three_of_a_kind_hand" do
      it "returns" do
        expect(three_of_a_kind_hand.pair_evaluater).to eql(:three_of_a_kind)
      end
    end
    context "straight_hand" do
      it "returns" do
        expect(straight_hand.pair_evaluater).to eql(false)
      end
    end
    context "flush_hand" do
      it "returns" do
        expect(flush_hand.pair_evaluater).to eql(false)
      end
    end
    context "full_house_hand" do
      it "returns" do
        expect(full_house_hand.pair_evaluater).to eql(:full_house)
      end
    end
    context "four_of_a_kind_hand" do
      it "returns" do
        expect(four_of_a_kind_hand.pair_evaluater).to eql(:four_of_a_kind)
      end
    end
    context "straight_flush_hand" do
      it "returns" do
        expect(straight_flush_hand.pair_evaluater).to eql(false)
      end
    end
  end
end

describe "#run" do
  it "returns 376" do
    expect(run).to eql(376)
  end
end
