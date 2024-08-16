require "thor"
require "zip"

module Yamlator
  class CLI < Thor
    MAX_FILE_COUNT = 250

    desc "yaml_file", "check a single YAML file."
    def yaml_file(file_path)
      text = File.read(file_path)
      sample = Yamlator::Sample.new(text)
      if sample.syntax_error?
        puts
        puts sample.syntax_error
        puts sample.error_line_text
      end
    end

    desc "zip_file", "check all YAML files contained in a ZIP file."
    def zip_file(file_path)
      Zip::File.open(File.open(file_path)) do |zip_file|
        samples = []
        file_count = 0

        zip_file.each do |yaml_file|
          next if yaml_file.ftype == :directory || !([".yml", ".yaml"].include? File.extname(yaml_file.name))
          text = yaml_file.get_input_stream.read
          samples << Yamlator::Sample.new(text, file_name: yaml_file.name)
          file_count += 1
        end

        samples.each do |sample|
          if sample.syntax_error?
            puts
            puts sample.syntax_error
            puts sample.error_line_text
          end
        end
      end
    end
  end
end
