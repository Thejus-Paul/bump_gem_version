# frozen_string_literal: true

require "test_helper"

class TestBumpGemVersion < Minitest::Test
  def setup
    Dir.chdir("./test/dummy") unless Dir.pwd.end_with?("dummy")
    @version_file = File.open("./lib/dummy/version.rb", "r")
    @gemfile_lock_file = File.open("./Gemfile.lock", "r")
  end

  def teardown = BumpGemVersion::CLI.new.exact("0.1.0")

  def test_that_it_gives_the_current_version = assert_expected_version("0.1.0")

  def test_that_it_does_not_give_wrong_current_version = refute_expected_version("0.1.1")

  def test_that_it_bumps_the_patch_version
    BumpGemVersion::CLI.new.patch

    assert_expected_version("0.1.1")
  end

  def test_that_it_does_not_bump_minor_version_when_patch_method_is_called
    BumpGemVersion::CLI.new.patch

    refute_expected_version("0.2.0")
  end

  def test_that_it_bumps_the_minor_version
    BumpGemVersion::CLI.new.minor

    assert_expected_version("0.2.0")
  end

  def test_that_it_does_not_bump_the_patch_version_when_minor_method_is_called
    BumpGemVersion::CLI.new.minor

    refute_expected_version("0.1.1")
  end

  def test_that_it_bumps_the_major_version
    BumpGemVersion::CLI.new.major

    assert_expected_version("1.0.0")
  end

  def test_that_it_does_not_bump_the_minor_version_when_major_method_is_called
    BumpGemVersion::CLI.new.major

    refute_expected_version("0.2.0")
  end

  def test_that_it_bumps_the_exact_version
    BumpGemVersion::CLI.new.exact("1.2.3")

    assert_expected_version("1.2.3")
  end

  def test_that_it_does_not_bump_patch_version_when_exact_method_is_called
    BumpGemVersion::CLI.new.exact("1.2.3")

    refute_expected_version("0.1.1")
  end

  def test_that_it_bumps_the_version_with_given_patch_label
    BumpGemVersion::CLI.new.labels("patch")

    assert_expected_version("0.1.1")
  end

  def test_that_the_version_does_not_remains_same_when_patch_label_is_given
    BumpGemVersion::CLI.new.labels("patch")

    refute_expected_version("0.1.0")
  end

  def test_that_it_does_not_bump_minor_version_when_patch_label_is_given
    BumpGemVersion::CLI.new.labels("patch")

    refute_expected_version("0.2.0")
  end

  def test_that_it_does_not_bump_major_version_when_patch_label_is_given
    BumpGemVersion::CLI.new.labels("patch")

    refute_expected_version("1.0.0")
  end

  def test_that_it_bumps_the_version_with_given_minor_label
    BumpGemVersion::CLI.new.labels("minor")

    assert_expected_version("0.2.0")
  end

  def test_that_the_version_does_not_remains_same_when_minor_label_is_given
    BumpGemVersion::CLI.new.labels("minor")

    refute_expected_version("0.1.0")
  end

  def test_that_it_does_not_bump_patch_version_when_minor_label_is_given
    BumpGemVersion::CLI.new.labels("minor")

    refute_expected_version("0.1.1")
  end

  def test_that_it_does_not_bump_major_version_when_minor_label_is_given
    BumpGemVersion::CLI.new.labels("minor")

    refute_expected_version("1.0.0")
  end

  def test_that_it_bumps_the_version_with_given_major_label
    BumpGemVersion::CLI.new.labels("major")

    assert_expected_version("1.0.0")
  end

  def test_that_the_version_does_not_remains_same_when_major_label_is_given
    BumpGemVersion::CLI.new.labels("major")

    refute_expected_version("0.1.0")
  end

  def test_that_it_does_not_bump_the_patch_version_when_major_label_is_given
    BumpGemVersion::CLI.new.labels("major")

    refute_expected_version("0.1.1")
  end

  def test_that_it_does_not_bump_the_minor_version_when_major_label_is_given
    BumpGemVersion::CLI.new.labels("major")

    refute_expected_version("0.2.0")
  end

  def test_that_it_bumps_the_version_with_first_bump_type_label_from_multiple_bump_type_labels
    BumpGemVersion::CLI.new.labels("major,minor")

    assert_expected_version("1.0.0")
  end

  def test_that_the_version_does_not_remain_the_same_when_multiple_bump_type_labels_are_provided
    BumpGemVersion::CLI.new.labels("major,minor")

    refute_expected_version("0.1.0")
  end

  def test_that_it_does_not_bump_the_patch_version_when_patch_label_is_not_the_first_bump_type_label
    BumpGemVersion::CLI.new.labels("major,patch,minor")

    refute_expected_version("0.1.1")
  end

  def test_that_it_does_not_bump_the_minor_version_when_minor_version_is_not_the_first_bump_type_label
    BumpGemVersion::CLI.new.labels("major,minor")

    refute_expected_version("0.2.0")
  end

  def test_that_it_bumps_the_version_with_first_bump_type_label_from_multiple_given_labels
    BumpGemVersion::CLI.new.labels("bug,patch")

    assert_expected_version("0.1.1")
  end

  def test_that_the_version_does_not_remain_the_same_when_bump_type_label_is_present_in_the_given_labels
    BumpGemVersion::CLI.new.labels("bug,patch")

    refute_expected_version("0.1.0")
  end

  def test_that_it_does_not_bump_the_minor_version_when_the_first_bump_type_label_is_patch
    BumpGemVersion::CLI.new.labels("bug,patch")

    refute_expected_version("0.2.0")
  end

  def test_that_it_does_not_bump_the_major_version_when_the_first_bump_type_label_is_patch
    BumpGemVersion::CLI.new.labels("bug,patch")

    refute_expected_version("1.0.0")
  end

  def test_that_it_bumps_the_patch_version_when_provided_label_is_not_a_bump_type_label_but_default_label_is_patch
    bump_label_with_options(labels: "bug", default: "patch")

    assert_expected_version("0.1.1")
  end

  def test_that_the_version_does_not_remain_the_same_when_default_label_is_patch
    bump_label_with_options(labels: "bug", default: "patch")

    refute_expected_version("0.1.0")
  end

  def test_that_it_does_not_bump_the_minor_version_when_default_label_is_patch
    bump_label_with_options(labels: "bug", default: "patch")

    refute_expected_version("0.2.0")
  end

  def test_that_it_does_not_bump_the_major_version_when_default_label_is_patch
    bump_label_with_options(labels: "bug", default: "patch")

    refute_expected_version("1.0.0")
  end

  def test_that_it_bumps_the_minor_version_when_default_label_is_patch_and_provided_labels_include_minor_label
    bump_label_with_options(labels: "bug,minor", default: "patch")

    assert_expected_version("0.2.0")
  end

  def test_that_the_version_does_not_remain_the_same_when_the_provided_labels_include_minor_label
    bump_label_with_options(labels: "bug,minor", default: "patch")

    refute_expected_version("0.1.0")
  end

  def test_that_it_does_not_bump_the_patch_version_when_provided_labels_include_minor_label
    bump_label_with_options(labels: "bug,minor", default: "patch")

    refute_expected_version("0.1.1")
  end

  def test_that_it_does_not_bump_the_major_version_when_provided_labels_include_minor_label
    bump_label_with_options(labels: "bug,minor", default: "patch")

    refute_expected_version("1.0.0")
  end

  def test_that_it_bumps_the_major_version_when_default_label_is_major_and_no_labels_are_provided
    bump_label_with_options(labels: "", default: "major")

    assert_expected_version("1.0.0")
  end

  def test_that_the_version_does_not_remain_the_same_when_default_label_is_major_and_no_labels_are_provided
    bump_label_with_options(labels: "", default: "major")

    refute_expected_version("0.1.0")
  end

  def test_that_it_does_not_bump_the_patch_version_when_default_label_is_major_and_no_labels_are_provided
    bump_label_with_options(labels: "", default: "major")

    refute_expected_version("0.1.1")
  end

  def test_that_it_does_not_bump_the_minor_version_when_default_label_is_major_and_no_labels_are_provided
    bump_label_with_options(labels: "", default: "major")

    refute_expected_version("0.2.0")
  end

  private

  def bump_label_with_options(labels: "", default: "")
    bump_gem_version = BumpGemVersion::CLI.new
    bump_gem_version.options = { default: }
    bump_gem_version.labels(labels)
  end

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
