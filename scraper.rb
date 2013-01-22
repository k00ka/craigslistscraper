require 'nokogiri'
require 'open-uri'

craigslist_apartments_url = "http://toronto.en.craigslist.ca/apa/"

craigslist_apartments = Nokogiri::HTML(open(craigslist_apartments_url))

page_contents = []

def parse_price(description)
  if description.match(/\$(\d+)/)
    price = description.match(/\$(\d+)/)
    return price[1]
  else
    return 0
  end
end

# Create a method to parse the number of bedrooms
def parse_number_of_bedrooms(description)
  # Craigslist uses a format for bedrooms that looks like this: 2br
  # The regular expression below will match any digits followed by "br"
  if description.match(/\d+br/)
    number_of_bedrooms = description.match(/\d+br/)
    # This will assign a string (e.g., "2br") to number_of_bedrooms
    # We need to strip out any non-digit characters ("br"), which we can do
    # using a second regular expression
    return number_of_bedrooms[0].match(/\d/).to_s
  else
    return 0
  end
end

craigslist_apartments.css('p.row').each do |item|
  apartment = Hash.new

  apartment["description"] = item.css('a').text
  apartment["price"] = parse_price(item.css('.itemph').text)

  # Let's now add the number of bedrooms to our hash
  apartment["number_of_bedrooms"] = parse_number_of_bedrooms(item.css('.itemph').text)

  page_contents << apartment

end

puts page_contents
