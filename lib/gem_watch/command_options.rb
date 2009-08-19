require "gem_watch"

class GemWatch::CommandOptions
  attr_accessor :smtp_host
  attr_accessor :smtp_port
  attr_accessor :email_recipients
  attr_accessor :email_subject
  attr_accessor :email_from
  attr_accessor :stdout
  attr_accessor :check_update_on
  
  Defaults = {
    # SMTP Part
    :smtp_host  => 'localhost',
    :smtp_port  => 25,
    # Email part
    :email_recipients => [],
    :email_subject    => "GemWatch has found something to report",
    :email_from       => "gemwatch@example.com",
    # Checks part
    :check_update_on => :all,
    # General part
    :stdout => true
  }
  
  def initialize
    Defaults.each {|key, value| send "#{key}=", value}
  end
  
  def email_recipients=(recipients)
    @email_recipients = case recipients.class.name
    when 'Array'
      recipients
    when 'String'
      recipients.split(',').collect {|email| email.strip}
    end
    @stdout = @email_recipients.empty?
  end
end