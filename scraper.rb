# Craigslist Scraper
require 'nokogiri'
require 'open-uri'

# Craigslist uses a format for apartment details that looks like this "$XXXX Xbr - XXXXft2" where the X's are digits.
# Using regular expressions we can pull this string apart into pieces:
# The price is a "$" followed by digits. In regexp syntax this is /\$\d+/.
# The number of bedrooms is a digit followed by "br". In regexp this is /\dbr/.
# The square footage is digits follows by "ft". In regexp this is /\d+ft/.

# Return a string representing the integer following the first dollar sign found in the argument
def parse_price(details)
  price = details.match(/\$(\d+)/)
  price ? price[1] : "price not found"
end

# Return a string representing the integer preceding the characters "br" found in the argument
def parse_bedrooms(details)
  bedrooms = details.match(/(\d)br/)
  bedrooms ? bedrooms[1] : "bedrooms not found"
end

# Apartments on Craigslist are contained in a list of "items" (their term).
# Grab the list and iterate through each item, creating a new "digest" (our term) for each apartment
def create_digest(html)
  apartments = []
  items = html.css('p.row')
  items.each do |item|
    details = item.css('.pl').text
    new_digest = {
      :description => item.css('a').text,
      :price => parse_price(item.css('.price').text),
      :bedrooms => parse_bedrooms(item.css('.pnr').text)
    }
    apartments << new_digest
  end
  apartments
end

craigslist_apartments_url = "http://toronto.en.craigslist.ca/apa/"
craigslist_apartments = Nokogiri::HTML(open(craigslist_apartments_url))
apartments = create_digest(craigslist_apartments)
# Output our new list of apartments unless we're running tests, then don't
puts apartments unless defined? MiniTest::Spec
