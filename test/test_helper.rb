$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "yamlator"

require "debug"
require "pathname"
require "minitest/autorun"

class TestHelper
  def self.fixture_path(file_name)
    File.join(File.expand_path(__dir__), "fixtures", file_name)
  end

  def self.read_fixture(file_name)
    File.read(fixture_path(file_name))
  end
end
