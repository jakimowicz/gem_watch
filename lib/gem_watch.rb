class GemWatch
  # Destination email(s) which check results will be sent
  attr_reader :email
  
  # Update object to perform check on
  attr_reader :update_on
  
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
  
  def run_checks
    @update_on.each {|check| check.run}
  end
  
  def passed?
    @update_on.all? {|check| check.passed?}
  end
  
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