# GemWatch regroups multiple checks and consolidates them in a pretty formated result.
class GemWatch
  # Update object to perform check on
  attr_reader :update_on
  
  # Initialize a new GemWatch object using <tt>params</tt>.
  # == params
  # <tt>:update</tt>: accepts a String of coma separated gem names or directly an Array of gem string names.
  def initialize(params = {})
    @update_on  = case params[:update].class
    when Array
      params[:update]
    when String
      params[:update].split(',').collect {|s| s.strip}
    else
      [params[:update]]
    end
    
    @update_on = @update_on.collect {|name| GemWatch::Check::Update.new name}    
  end
  
  # Run all checks
  def run_checks
    @update_on.each {|check| check.run}
  end
  
  # Returns true if all checks passed.
  def passed?
    @update_on.all? {|check| check.passed?}
  end
  
  # Formated results.
  def results
    if @update_on.any? {|check| !check.passed?}
      <<-EOS

Those gems can be updated to their latest version:

Name                Local     Remote
=========================================
#{@update_on.collect {|check| check.results}.join "\n"}

      EOS
    end
  end
end

require "gem_watch/checks/update"