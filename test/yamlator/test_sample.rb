require "test_helper"

class TestYamlatorSample < Minitest::Test
  def test_error_is_nil_with_valid_yaml
    valid_yaml = TestHelper.read_fixture("valid.yaml")
    sample = Yamlator::Sample.new(valid_yaml)

    refute sample.syntax_error?
    assert_nil sample.syntax_error
    assert_nil sample.error_line_text
  end

  def test_error_exists_with_invalid_yaml_backslashes
    invalid_yaml = TestHelper.read_fixture("invalid_backslash.yaml")
    sample = Yamlator::Sample.new(invalid_yaml)

    assert sample.syntax_error?
    assert_equal sample.syntax_error[:line], 4
    assert_equal sample.syntax_error[:column], 8
    assert_includes sample.syntax_error[:message], "found unknown escape character"
    assert_equal sample.error_line_text, '  bar: "This is a windows Filepath: C:\Documents\Newsletters\Summer2018.pdf"'
  end

  def test_error_exists_with_invalid_yaml_smart_quotes
    invalid_yaml = TestHelper.read_fixture("invalid_smart_quotes.yaml")
    sample = Yamlator::Sample.new(invalid_yaml)

    assert sample.syntax_error?
    assert_equal sample.syntax_error[:line], 4
    assert_equal sample.syntax_error[:column], 8
    assert_includes sample.syntax_error[:message], "found unexpected end of stream"
    assert_equal sample.error_line_text, '  bar: "fancy pants quotes”'
  end
end
