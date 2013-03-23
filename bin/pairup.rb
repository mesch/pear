#!/usr/bin/env ruby
require 'optparse'
require_relative '../lib/pair'

options = {force: false, required: []}
OptionParser.new do |opts|
    opts.banner = "Usage: pairup.rb [options]"

    opts.on("-r [[:ab,:any],[:cd,:ef],[:gh]]",
            "--require [[:ab,:cd],[:ef]]",
            "Requires a set of developers") do |required|
      options[:required] = eval(required)
    end

    opts.on_tail("-h", "--help", "Show this message") do
      puts opts
      exit
    end
end.parse!

ps = Pair::Selector.new()
pairing = ps.run(options[:required])
puts "#{Date.today.strftime('%a %m/%d/%Y')} => #{pairing.inspect}"
puts "days since pairing: #{ps.pair_group_info(pairing)}"
puts "minimum score: #{ps.calculate_score(pairing)}"
