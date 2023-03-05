# BumpGemVersion

BumpGemVersion is a gem that will simplify the way you build gems.

## Installation

Install the gem and add to the application's Gemfile by executing:

```sh
bundle add bump_gem_version
```

If bundler is not being used to manage dependencies, install the gem by executing:

```sh
gem install bump_gem_version
```

## Usage

```sh
bump_gem_version current # 0.1.0

bump_gem_version patch # 0.1.0 -> 0.1.1

bump_gem_version minor # 0.1.0 -> 0.2.0

bump_gem_version major # 0.1.0 -> 1.0.0

# To use with labels
bump_gem_version labels bug,patch # 0.1.0 -> 0.1.1
bump_gem_version labels feature,minor,patch # 0.1.0 -> 0.2.0
bump_gem_version labels breaking,major # 0.1.0 -> 1.0.0
bump_gem_version labels ${{ join(github.event.pull_request.labels.*.name, ',') }} # For GitHub PR labels

bump_gem_version exact 1.2.3 # 0.1.0 -> 1.2.3
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/thejus-paul/bump_gem_version>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/thejus-paul/bump_gem_version/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the BumpGemVersion project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/thejus-paul/bump_gem_version/blob/master/CODE_OF_CONDUCT.md).
