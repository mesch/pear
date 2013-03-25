require_relative 'pair/generator'
require_relative 'pair/selector'
require_relative 'pair/schedule'
require 'parseconfig'

module Pair
  config_file = File.join(File.expand_path(File.dirname(__FILE__)),'..','config')
  config = ParseConfig.new(config_file)
  @developers = config["developers"]
  @schedule_file = config["schedule_file"]
  @num_samples = config["num_samples"]

  def self.developers
    @developers ? eval(@developers) : []
  end

  def self.schedule_file
    @schedule_file ? @schedule_file : 'pairing_schedule.yml'
  end

  def self.num_samples
    @num_samples ? @num_samples.to_i : 1000
  end

end