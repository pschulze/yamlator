require "yaml"

module Yamlator
  class Sample
    attr_reader :text, :file_name, :syntax_error

    def initialize(text, file_name: nil, safe_load: true)
      @text = text
      @file_name = file_name
      @safe_load = safe_load
      parse_text
    end

    def syntax_error?
      !!syntax_error
    end

    def error_line_text
      return nil unless syntax_error?

      text.lines[syntax_error[:line] - 1]
    end

    private

    def parse_text
      if @safe_load
        YAML.safe_load(@text)
      else
        YAML.unsafe_load(@text)
      end
    rescue Psych::SyntaxError => e
      # TODO: Consider making syntax error it's own class?
      @syntax_error = {line: e.line, column: e.column, message: e.message}
    end
  end
end
