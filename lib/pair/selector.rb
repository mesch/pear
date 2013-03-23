module Pair
  class Selector
    DEVELOPERS = [:dj,:ja,:jr,:me,:nl,:pj,:pk,:tc]
    NUM_SAMPLES = 1000
    attr_accessor :schedule, :day

    def initialize()
      @schedule = Schedule.new()
      @day = Date.today
    end

    def run(required_pairs=[])
      #schedule.data.each { |k,v| puts "#{k} -> #{v.inspect}"}
      best_pair_group = []
      min_score = Float::MAX
      NUM_SAMPLES.times do |i|
        pair_group = Pair::Generator.new(DEVELOPERS.dup).random(required_pairs)
        #puts pair_group.inspect
        score = calculate_score(pair_group)
        #puts score
        if score < min_score
          best_pair_group = pair_group
          min_score = score
        end
      end
      schedule.add(day, best_pair_group)
      best_pair_group
    end

    def pair_group_info(pair_group)
      pair_group.map do |pair|
        schedule.days_since(pair)
      end
    end

    def calculate_score(pair_group)
      pair_group.map do |pair|
        number_of_days = schedule.days_since(pair)
        number_of_days.nil? ? 0.0 : 1.0/number_of_days
      end.reduce(:+)
    end

  end
end