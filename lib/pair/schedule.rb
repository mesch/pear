require 'yaml'

module Pair
  class Schedule

    SCHEDULE_FILE = 'pairing_schedule.yml'

    def initialize(file=SCHEDULE_FILE)
      @file = file
    end

    def data
      @data ||=
        begin
          YAML::load_file(@file) || {}
        rescue Errno::ENOENT
          {}
        end
    end

    def write(data)
      File.open(@file, 'w+') {|f| f.write(YAML::dump(data)) }
      @data = nil
    end

    def at(key)
      data[key]
    end

    def add(key,value)
      temp = data
      temp[key] = value
      write(temp)
    end

    def days_since(pair)
      days = data.keys.sort { |x,y| y <=> x }
      days.delete(Date.today)
      days.each do |day|
        if data[day].include?(pair) or data[day].include?(pair.reverse)
          return days_from_today(day)
        end
      end
      nil
    end

    private

    def days_from_today(date)
      (Date.today - date).to_i
    end

  end
end