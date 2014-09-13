# Recipe Search. Aggregated top five recipes from three websites.

require 'sinatra'
require 'nokogiri'
require 'open-uri'
require './scr_classes'

ep_search = EpSearch.new("peppers")
ar_search = ArSearch.new("peppers")
co_search = CoSearch.new("peppers")

# Results are to a Hash.

get '/' do
  @ar_search = ar_search.results
  @co_search = co_search.results
  @ep_search = ep_search.results
  erb :recipe_search
end


# helpers do 
#   def epicurious_add(result)
#     'http://www.epicurious.com' + result.at_css('.sr_lnk_box a')[:href]
#   end
# end

# system("open", "localhost:4567/")

# ep_search.search_results("steak") do |result|
# 	puts result.text.gsub!(/\s+/, " ")
# end