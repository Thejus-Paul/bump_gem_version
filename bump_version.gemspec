# frozen_string_literal: true

require_relative "lib/bump_version/version"

Gem::Specification.new do |spec|
  spec.name = "bump_version"
  spec.version = BumpVersion::VERSION
  spec.authors = ["Thejus Paul"]
  spec.email = ["thejuspaul@pm.me"]

  spec.summary = "BumpVersion is a gem that will simplify the way you build gems."
  spec.homepage = "https://rubygems.org/gems/bump_version"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/thejus-paul/bump_version"
  spec.metadata["changelog_uri"] = "https://github.com/thejus-paul/bump_version/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "thor", "~> 1.2"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rubocop", "~> 1.0"
  spec.add_development_dependency "rubocop-minitest", "~> 0.28"
  spec.add_development_dependency "rubocop-rake", "~> 0.6"
end
