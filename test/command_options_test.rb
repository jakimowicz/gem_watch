require 'test_helper'
require 'gem_watch/command_options'

class CommandOptionsTest < Test::Unit::TestCase
  context "initialize empty object" do
    setup do
      @options = GemWatch::CommandOptions.new
    end
    
    should "should initialize object with default values" do
      GemWatch::CommandOptions::Defaults.each do |key, value|
        assert_equal value, @options.send(key)
      end
    end
    
    should "email_recipients= accepts an Array attribute" do
      emails = ['bob@test.com', 'alice@test.com']
      @options.email_recipients = emails
      assert_equal emails, @options.email_recipients
    end
    
    should "email_recipients= accepts a String with only one email address" do
      email = "bob@test.com"
      @options.email_recipients = email
      assert_equal [email], @options.email_recipients
    end
    
    should "email_recipients= accepts a String with coma separated emails" do
      emails = ['bob@test.com', 'alice@test.com']
      @options.email_recipients = emails.join(', ')
      assert_equal emails, @options.email_recipients
    end
    
    should "stdout false if email_recipients is not empty" do
      @options.email_recipients = 'bob@test.com'
      assert_false @options.stdout
    end

    should "stdout false if email_recipients is empty" do
      @options.email_recipients = ''
      assert_true @options.stdout
    end
  end
end