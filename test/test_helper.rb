require 'rubygems'
gem 'test-unit'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'gem_watch'

class Test::Unit::TestCase
end
