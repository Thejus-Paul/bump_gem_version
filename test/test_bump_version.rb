# frozen_string_literal: true

require "test_helper"

class TestBumpVersion < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::BumpVersion::VERSION
  end
end
