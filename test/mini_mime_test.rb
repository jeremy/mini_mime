require 'test_helper'
require 'mime/types/columnar'

class MiniMimeTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::MiniMime::VERSION
  end


  def test_content_type
    # keep lotus alive cause these files are EVERYWHERE
    assert_equal "application/vnd.lotus-1-2-3", MiniMime.lookup_by_filename("a.123").content_type
    assert_equal "application/x-compress", MiniMime.lookup_by_filename("a.Z").content_type
    assert_equal "application/vnd.groove-tool-message", MiniMime.lookup_by_filename("a.gtm").content_type
    assert_equal "application/vnd.HandHeld-Entertainment+xml", MiniMime.lookup_by_filename("a.zmm").content_type
    assert_nil MiniMime.lookup_by_filename("a.frog")
  end

  def test_binary
    # note this is not strictly correct but .Z is the only
    # upper case extension, being correct here seems overkill
    assert MiniMime.lookup_by_filename("a.z").binary?
    assert MiniMime.lookup_by_filename("a.Z").binary?
    refute MiniMime.lookup_by_filename("a.txt").binary?
    assert_nil MiniMime.lookup_by_filename("a.frog")
  end

  def test_binary_content_type
    assert MiniMime.lookup_by_content_type("application/x-compress").binary?
    assert_nil MiniMime.lookup_by_content_type("something-fake")
    refute MiniMime.lookup_by_content_type("text/plain").binary?
  end

  def test_full_parity_with_mime_types
    exts = Set.new
    MIME::Types.each do |type|
      type.extensions.each{|ext| exts << ext}
    end

    exts.each do |ext|
      type = MIME::Types.type_for("a.#{ext}").first
      assert_equal type.content_type, MiniMime.lookup_by_filename("a.#{ext}").content_type
    end
  end
end
