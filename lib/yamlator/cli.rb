require "thor"
require "zip"

module Yamlator
  class CLI < Thor
    SAFE_LOAD_OPTIONS = {
      aliases: "-s",
      type: :boolean,
      default: true,
      desc: "Determines whether to safely load YAML. " \
            "See Ruby documentation for Psych::safe_load for more details. " \
            "Note: Disabling safe_load should NOT be used to parse untrusted documents."
    }

    desc "yaml_file", "check a single YAML file."
    method_option :safe_load, SAFE_LOAD_OPTIONS
    def yaml_file(file_path)
      text = File.read(file_path)
      sample = Yamlator::Sample.new(text, safe_load: options.safe_load)
      if sample.syntax_error?
        puts
        puts sample.syntax_error
        puts sample.error_line_text
      end
    end

    desc "zip_file", "check all YAML files contained in a ZIP file."
    method_option :safe_load, SAFE_LOAD_OPTIONS
    def zip_file(file_path)
      Zip::File.open(File.open(file_path)) do |zip_file|
        samples = []
        file_count = 0

        zip_file.each do |yaml_file|
          next if yaml_file.ftype == :directory || !([".yml", ".yaml"].include? File.extname(yaml_file.name))

          text = yaml_file.get_input_stream.read
          samples << Yamlator::Sample.new(text, file_name: yaml_file.name, safe_load: options.safe_load)
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
