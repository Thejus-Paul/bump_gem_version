# frozen_string_literal: true

require "test_helper"

class TestBumpGemVersion < Minitest::Test
  def setup
    Dir.chdir("./test/dummy") unless Dir.pwd.end_with?("dummy")
    @version_file = File.open("./lib/dummy/version.rb", "r")
    @gemfile_lock_file = File.open("./Gemfile.lock", "r")
  end

  def teardown = BumpGemVersion::CLI.new.exact("0.1.0")

  def test_that_it_gives_the_current_version
    assert_expected_version("0.1.0")

    refute_expected_version("0.1.1")
    refute_expected_version("0.2.0")
    refute_expected_version("1.0.0")
  end

  def test_that_it_bumps_the_patch_version
    BumpGemVersion::CLI.new.patch

    assert_expected_version("0.1.1")

    refute_expected_version("0.1.0")
    refute_expected_version("0.2.0")
    refute_expected_version("1.0.0")
  end

  def test_that_it_bumps_the_minor_version
    BumpGemVersion::CLI.new.minor

    assert_expected_version("0.2.0")

    refute_expected_version("0.1.0")
    refute_expected_version("0.1.1")
    refute_expected_version("1.0.0")
  end

  def test_that_it_bumps_the_major_version
    BumpGemVersion::CLI.new.major

    assert_expected_version("1.0.0")

    refute_expected_version("0.1.0")
    refute_expected_version("0.1.1")
    refute_expected_version("0.2.0")
  end

  def test_that_it_bumps_the_exact_version
    BumpGemVersion::CLI.new.exact("1.2.3")

    assert_expected_version("1.2.3")

    refute_expected_version("0.1.0")
    refute_expected_version("0.1.1")
    refute_expected_version("0.2.0")
    refute_expected_version("1.0.0")
  end

  def test_that_it_bumps_the_version_with_given_patch_label
    BumpGemVersion::CLI.new.labels("patch")

    assert_expected_version("0.1.1")

    refute_expected_version("0.1.0")
    refute_expected_version("0.2.0")
    refute_expected_version("1.0.0")
  end

  def test_that_it_bumps_the_version_with_given_minor_label
    BumpGemVersion::CLI.new.labels("minor")

    assert_expected_version("0.2.0")

    refute_expected_version("0.1.0")
    refute_expected_version("0.1.1")
    refute_expected_version("1.0.0")
  end

  def test_that_it_bumps_the_version_with_given_major_label
    BumpGemVersion::CLI.new.labels("major")

    assert_expected_version("1.0.0")

    refute_expected_version("0.1.0")
    refute_expected_version("0.1.1")
    refute_expected_version("0.2.0")
  end

  def test_that_it_bumps_the_version_with_first_bump_type_label_from_multiple_bump_type_labels
    BumpGemVersion::CLI.new.labels("major,minor")

    assert_expected_version("1.0.0")

    refute_expected_version("0.1.0")
    refute_expected_version("0.1.1")
    refute_expected_version("0.2.0")
  end

  def test_that_it_bumps_the_version_with_first_bump_type_label_from_multiple_given_labels
    BumpGemVersion::CLI.new.labels("bug,patch")

    assert_expected_version("0.1.1")

    refute_expected_version("0.1.0")
    refute_expected_version("0.2.0")
    refute_expected_version("1.0.0")
  end

  private

  def assert_expected_version(version)
    assert_output(/#{version}/) { BumpGemVersion::CLI.new.current }
    assert_match(/#{version}/, @version_file.read)
    assert_match(/dummy\s{1}\(#{version}\)/, @gemfile_lock_file.read)
  end

  def refute_expected_version(version)
    refute_match(/#{version}/, @version_file.read)
    refute_match(/dummy\s{1}\(#{version}\)/, @gemfile_lock_file.read)
  end
end
