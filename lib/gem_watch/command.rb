# Pure ruby requires
require 'optparse'
require 'net/smtp'

# Gems
require 'yaml'

# Internal stuff
require "gem_watch"
require "gem_watch/command_options"

class GemWatch::Command
  def initialize
    @options = GemWatch::CommandOptions.new
  end
  
  def run(args = {})
    parse_options args
    gw = GemWatch.new(:update => @options.check_update_on)
    gw.run_checks
    if gw.passed?
      say "Nothing to report."
    else
      say gw.results
    end
  end
  
  def say(str)
    if @options.stdout or @options.email_recipients.empty?
      puts str
    else
      send_email str
    end
  end
  
  def send_email(message)
    email = <<-END_OF_MESSAGE
From: GemWatch <#{@options.email_from}>
To: %s
Subject: #{@options.email_subject}

#{message}
END_OF_MESSAGE

  	Net::SMTP.start(@options.smtp_host, @options.smtp_port) do |smtp|
      @options.email_recipients.each do |recipient|
  		  smtp.send_message email % recipient, @options.email_from, recipient
		  end
  	end
  end
  
  def parse_options(args)
    OptionParser.new do |opts|
      opts.banner = "Usage: gemwatch [options]"
      
      opts.separator ""
      opts.separator "Checks options:"
      
      opts.on "-u", "--check-update-on=<all|gem1, gem2, ...>", "Precise what are the gems to check for the update." do |gems|
        @options.check_update_on = gems
      end
      
      opts.separator ""
      opts.separator "Email options:"
      
      opts.on "-e", "--email-recipient=email1, email2, ...", "Email address to send results." do |email|
        @options.email_recipients = email
        @options.stdout = false
      end
      
      opts.on "-s", "--email-subject=subject", "Subject used in the email." do |subject|
        @options.email_subject = subject
      end
      
      opts.on "-f", "--email-from=email", "Email's sender." do |email|
        @options.email_recipient = email.split(',').collect {|email| email.strip}
        @options.stdout = false
      end
      
      opts.separator ""
      opts.separator "SMTP options:"
      
      opts.on "--smtp-host=localhost", "SMTP host to connect to send emails." do |host|
        @options.smtp_host = host
      end
      
      opts.on "--smtp-port=25", "SMTP port to connect to send emails." do |port|
        @options.smtp_port = port
      end
      
      opts.separator ""
      opts.separator "General options:"
      
      opts.on "-c", "--config=config.yml", "YAML configuration file. Overrides command line attributes." do |config_file|
        y = YAML.parse_file(config_file)
        GemWatch::CommandOptions::Defaults.each_key do |key|
          value = yaml_value(y, key.to_s)
          @options.send("#{key}=", value) if value
        end
      end
      
      opts.on "-S", "--stdout", "Display results on stdout instead of mailing them." do
        @options.stdout = true
      end
      
      opts.on_tail "-h", "--help", "Show this message" do
        puts opts
        exit
      end
      
      opts.parse!(args)
    end
  end
  
  def yaml_value(yaml, key)
    if key.include?('_')
      first_key, sep, rest = key.partition('_')
      yaml_value yaml[first_key], rest
    else
      yaml[key].value rescue nil
    end
  end
end