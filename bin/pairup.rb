#!/usr/bin/env ruby
require 'optparse'
require_relative '../lib/pair'

options = {force: false, required: [], anchors: []}
OptionParser.new do |opts|
    opts.banner = "Usage: pairup.rb [options]"

    opts.on("-r [[:ab,:cd],[:ef]]",
            "--require [[:ab,:cd],[:ef]]",
            "Require pairs or solos") do |required|
      options[:required] = eval(required)
    end

    opts.on("-a [:ab, :cd]",
            "--anchor [:ab, :cd]",
            "Require anchors") do |anchors|
      options[:anchors] = eval(anchors)
    end

    opts.on_tail("-h", "--help", "Show this message") do
      puts opts
      exit
    end
end.parse!

ps = Pair::Selector.new()
pairing = ps.run([options[:required]],options[:anchors])
puts "#{Date.today.strftime('%a %m/%d/%Y')} => #{pairing.inspect}"
puts "days since pairing: #{ps.pair_combination_info(pairing)}"
puts "minimum score: #{ps.calculate_score(pairing)}"
