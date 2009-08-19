require "gem_watch"

# Implements a check which will run some tests on one or multiple gems.
# Negative results that need to be noticed are stored in the <tt>impacts</tt> hash.
# This class implements basic behavior for check, specific test implementation
# and interpretation is done in the children classes.
class GemWatch::Check
  # Stores the gem name to check on
  attr_reader :gem_name
  
  # Hash to store which gem has failed check and why
  attr_reader :impacts
  
  # Take a <tt>gem_name</tt> to check.
  def initialize(gem_name = :all)
    @gem_name = gem_name
    @impacts = {}
  end
  
  # Run check on <tt>gem_name</tt>.
  def run
    raise "Not implemented for this check."
  end
  
  # Returns true if test was passed, false otherwise.
  def passed?
    @impacts.empty?
  end

  # Pretty displays of results (interpretation of <tt>impacts</tt>).
  def results
    @impacts.inspect
  end
end