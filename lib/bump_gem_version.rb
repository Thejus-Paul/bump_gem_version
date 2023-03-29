# frozen_string_literal: true

require_relative "bump_gem_version/version"
require "thor"

module BumpGemVersion
  # All the CLI commands are defined here
  class CLI < Thor
    BUMPS         = %w[major minor patch pre].freeze
    PRERELEASE    = ["alpha", "beta", "rc", nil].freeze
    VERSION_REGEX = /(\d+\.\d+\.\d+(?:-(?:#{PRERELEASE.compact.join('|')}))?)/

    desc "current", "Get the current version of your gem"
    def current = puts(current_version[0])

    desc "major", "Bump the major version of your gem"
    def major = bump_gem_version("major")

    desc "minor", "Bump the minor version of your gem"
    def minor = bump_gem_version("minor")

    desc "patch", "Bump the patch version of your gem"
    def patch = bump_gem_version("patch")

    desc "label", "Bump the version of your gem from the given labels"
    def labels(labels)
      bump_type = labels.split(",").find { |label| BUMPS.include?(label) }
      bump_type ? bump_gem_version(bump_type) : puts("Error: Unable to find a valid bump label.")
    end

    desc "exact", "Bump the version of your gem to the given version"
    def exact(version) = bump_exact_version(version)

    private

    def bump_exact_version(version)
      file = current_version[1]
      replace_version_in_file(file, version)
      replace_version_in_gemfile_lock_file("Gemfile.lock", version)
    end

    def bump_gem_version(bump_type)
      file = current_version[1]
      new_version = updated_version(bump_type)
      replace_version_in_file(file, new_version)
      replace_version_in_gemfile_lock_file("Gemfile.lock", new_version)
    end

    def updated_version(bump_type)
      version, = current_version
      major, minor, patch = version.split(".")

      case bump_type
      when "major"
        "#{major.to_i + 1}.0.0"
      when "minor"
        "#{major}.#{minor.to_i + 1}.0"
      when "patch"
        "#{major}.#{minor}.#{patch.to_i + 1}"
      end
    end

    def current_version
      version, file = (
        version_from_version_rb ||
        version_from_lib_rb
      )
      puts "Error: Unable to find the version." unless version

      [version, file]
    end

    def version_from_version_rb
      files = Dir.glob("lib/**/version.rb")
      files.detect do |file|
        version_and_file = extract_version_from_file(file)
        return version_and_file if version_and_file
      end
    end

    def version_from_lib_rb
      files = Dir.glob("lib/**/*.rb")
      file = files.detect do |f|
        File.read(f) =~ /^\s+VERSION = ['"](#{VERSION_REGEX})['"]/i
      end
      [Regexp.last_match(1), file] if file
    end

    def extract_version_from_file(file)
      version = File.read(file)[VERSION_REGEX]
      return unless version

      [version, file]
    end

    def replace_version_in_file(file, version)
      content = File.read(file)
      content.gsub!(VERSION_REGEX, version)
      File.write(file, content)
    end

    def replace_version_in_gemfile_lock_file(file, version)
      gem_name = current_gem_name
      content = File.read(file)
      content.gsub!(/#{gem_name} \((#{VERSION_REGEX})\)/, "#{gem_name} (#{version})")
      File.write(file, content)
    end

    def current_gem_name
      gemspec = Dir.glob("*.gemspec").first
      File.read(gemspec)[/\.name\s+=\s+['"](.+)['"]/i, 1]
    end
  end
end
