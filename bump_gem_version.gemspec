# frozen_string_literal: true

require_relative "lib/bump_gem_version/version"

Gem::Specification.new do |spec|
  spec.name = "bump_gem_version"
  spec.version = BumpGemVersion::VERSION
  spec.authors = ["Thejus Paul"]
  spec.email = ["thejuspaul@pm.me"]

  spec.summary = "BumpGemVersion is a gem that will simplify the way you build gems."
  spec.homepage = "https://rubygems.org/gems/bump_gem_version"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/thejus-paul/bump_gem_version"
  spec.metadata["changelog_uri"] = "https://github.com/Thejus-Paul/bump_gem_version/blob/main/CHANGELOG.md"
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
end
