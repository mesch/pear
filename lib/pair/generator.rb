module Pair
  class Generator
    attr_accessor :developers, :pairs

    def initialize(developers)
      @developers = developers
      @pairs = []
    end

    def random(required_pairs)
      remove_developers(required_pairs)
      required_pairs.each do |required_pair|
        pairs << generate_required_pair(required_pair)
      end
      while developers.size > 0
        pairs << generate_pair()
      end
      pairs
    end

    private

    def generate_required_pair(required_pair)
      if required_pair.last == :any
        required_pair[1] = developers.sample
      end
      remove_developers(required_pair)
    end

    def generate_pair(required_pair=nil)
      pair = developers.sample(2)
      remove_developers(pair)
    end

    def remove_developers(remove_list)
      remove_list.flatten.each { |elem| developers.delete(elem) }
    end

  end
end