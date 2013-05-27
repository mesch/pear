module Pair
  class Generator
    attr_accessor :pair_combinations
    attr_reader :developers, :required_anchors

    ### TODO: test for required_anchors in required_pairs
    def initialize(developers,required_pairs=[[]],required_anchors=[])
      @developers = developers
      @pair_combinations = required_pairs
      @required_anchors = required_anchors
    end

    def combinations()
      add_anchors
      until done? do
        add_pair
      end
      pair_combinations
    end

    private

    def add_anchors
      new_combinations = []
      required_anchors.each do |anchor|
        pair_combinations.each do |pair_combination|
          remaining_developers = developers - pair_combination.flatten - required_anchors
          remaining_developers.each do |developer|
            new_combinations << (pair_combination.dup << [anchor, developer])
          end
        end
        @pair_combinations = new_combinations
      end
    end

    def done?
      pair_combinations.each do |pair_combination|
        if pair_combination.flatten.sort != developers.sort
          return false
        end
      end
      true
    end

    def add_pair
      new_combinations = []
      pair_combinations.each do |pair_combination|
        remaining_developers = developers - pair_combination.flatten
        if remaining_developers.size.odd?
          new_combinations << (pair_combination.dup << [remaining_developers.first])
        end
        first = remaining_developers.delete(remaining_developers.first)
        remaining_developers.each do |developer|
          new_combinations << (pair_combination.dup << [first,developer])
        end
      end
      @pair_combinations = new_combinations
    end

  end
end