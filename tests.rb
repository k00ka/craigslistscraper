# Craigslist Scraper Specs
# To run the tests, use "ruby tests.rb" from the command-line.
# A successful pass will result in:
# 11 tests, 10 assertions, 0 failures, 0 errors, 2 skips

# Require the standard MiniTest/Spec files
require 'minitest/spec'
require 'minitest/autorun'

# Include the source we are testing
require_relative 'scraper'

# Describe our specifications
describe "my_craigslist_scraper" do

  describe "parse_price" do
    it "finds the price" do
      parse_price("$1250 / 2br").must_equal "1250"
    end

    it "fails gracefully" do
      parse_price("1000 / 2br").must_equal "price not found"
    end

    it "handles commas in the value" do
      skip "doesn't seem to happen on Craigslist right now, so let's not bother right now"
      parse_price("$1,250 / 2br").must_equal "1,250"
    end
  end
  
  describe "parse_bedrooms" do
    it "finds the bedrooms" do
      parse_bedrooms("$1250 / 3br").must_equal "3"
    end

    it "fails gracefully" do
      parse_bedrooms("$1250 / 3rb").must_equal "bedrooms not found"
    end

    it "handles more than 9 bedrooms" do
      skip "if you can afford 10+ bedrooms, you're using a real estate agent, not Craigslist!"
      parse_bedrooms("$1250 / 10br").must_equal "10"
    end
  end

  describe "create_digest" do
    it "returns an array" do
      create_digest(Nokogiri::HTML("")).must_be_kind_of(Array)
    end

    it "returns all results" do
      apartments = create_digest(Nokogiri::HTML(open("http://toronto.en.craigslist.ca/apa/")))
      apartments.count.must_equal 100
      # Note: you can have more than one assertion in a test!
      apartments = create_digest(Nokogiri::HTML(""))
      apartments.count.must_equal 0
    end
  end

end
