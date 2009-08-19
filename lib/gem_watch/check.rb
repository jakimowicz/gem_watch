require "gem_watch"

class GemWatch::Check
  # Stores the gem name to check on
  attr_reader :gem_name
  
  # Hash to store which gem has failed check and why
  attr_reader :impacts
  
  def initialize(gem_name = :all)
    @gem_name = gem_name
    @impacts = {}
  end
  
  def run
    raise "Not implemented for this check."
  end
  
  def passed?
    @impacts.empty?
  end
  
  def results
    @impacts.inspect
  end
end