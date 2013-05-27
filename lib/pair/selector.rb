module Pair
  class Selector
    attr_accessor :schedule, :day

    ### TODO rspec tests?
    def initialize()
      @schedule = Schedule.new()
      @day = Date.today
    end

    def run(required_pairs=[[]],required_anchors=[])
      #schedule.data.each { |k,v| puts "#{k} -> #{v.inspect}"}
      best_combination = []
      min_score = Float::MAX
      pair_combinations = Pair::Generator.new(Pair.developers,required_pairs,required_anchors).combinations
      pair_combinations.each do |pair_combination|
        #puts pair_combination.inspect
        score = calculate_score(pair_combination)
        #puts score
        if score < min_score
          best_combination = pair_combination
          min_score = score
        end
      end
      schedule.add(day, best_combination)
      best_combination
    end

    def pair_combination_info(pair_combination)
      pair_combination.map do |pair|
        schedule.days_since(pair)
      end
    end

    def calculate_score(pair_combination)
      days_since_pairing(pair_combination).map do |days|
        days.nil? ? 0.0 : 1.0/(days**2)
      end.reduce(:+)
    end

    def days_since_pairing(pair_combination)
      pair_combination.map { |pair| schedule.days_since(pair) }
    end

  end
end