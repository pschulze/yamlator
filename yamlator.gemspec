require_relative "lib/yamlator/version"

Gem::Specification.new do |spec|
  spec.name = "yamlator"
  spec.version = Yamlator::VERSION
  spec.authors = ["Peter Schulze"]
  spec.email = ["p.schulze@me.com"]

  spec.summary = "CLI for parsing YAML and displaying sytnax errors."
  spec.homepage = "https://github.com/pschulze/yamlator"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thor"
  spec.add_dependency "rubyzip"
end
