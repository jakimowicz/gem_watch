require 'test_helper'
require 'gem_watch/command'

# We must access to options in order to check them
class GemWatch::Command
  attr_reader :options
end

class CommandTest < Test::Unit::TestCase
  
  YamlData = {'stdout' => '1', 'email' => {'recipients' => 'bob@test.com, alice@test.com'}}
  MinimalYamlData = {'email' => {'recipients' => 'bob@test.com'}}
  
  context "initialize empty command object and get access to protected stuff" do
    setup do
      GemWatch::Command.send(:public, *GemWatch::Command.protected_instance_methods)
      @command = GemWatch::Command.new
    end
  
    context "parse yaml data" do
      setup do
        @yaml = YAML.parse(YamlData.to_yaml)
      end
    
      should "yaml_value returns value of a yaml object if key has no underscore" do
        assert_equal YamlData['stdout'], @command.yaml_value(@yaml, 'stdout')
      end
    
      should "yaml_value returns nested value if an underscore is present in key name" do
        assert_equal YamlData['email']['recipients'], @command.yaml_value(@yaml, 'email_recipients')
      end
    
      should "yaml_value returns nil if key is not found" do
        assert_nil @command.yaml_value(@yaml, 'boggy_key')
      end
    end # context "parse yaml data"
    
    should "parse_options should set stdout to true if both email and stdout options are set" do
      @command.parse_options ["--email-recipient=bob@test.com", "--stdout"]
      assert_true @command.options.stdout
    end
    
    should "parse_options handle a yaml file with no check definition and use default values" do
      @command.parse_options ["--config=test/minimal_yaml_data.yml"]
      assert_equal ['bob@test.com'], @command.options.email_recipients
    end
    
    should "parse_options handle a complete yaml file" do
      @command.parse_options ["--config=test/complete_yaml_data.yml"]
      assert_equal ['admin@example.com'],   @command.options.email_recipients
      assert_equal "Critical update !",     @command.options.email_subject
      assert_equal "bob@service.com",       @command.options.email_from
      assert_equal "127.0.0.1",             @command.options.smtp_host
      assert_equal "25",                    @command.options.smtp_port
      assert_equal "super_security, rails", @command.options.check_update_on
    end
    
  end # context "initialize empty command ..."
  
end