require 'nokogiri'
require 'open-uri'

class PageSearch
  attr_accessor :results, :result_links

  def initialize

  end
  
  def search(str)
    self.search_url.gsub!(/_search_term_/, str)
  end

  def get_data(url)
   Nokogiri::HTML(open(url))
  end

  def url(key)
    urls = {
      "ar" => "http://allrecipes.com/search/default.aspx?qt=k&wt=_search_term_&rt=r&origin=Home%20Page&vm=l&p34=SR_ListView",
      "co" => "http://www.cooks.com/rec/search?q=_search_term_",
      "ep" => "http://www.epicurious.com/tools/searchresults?search=_search_term_&type=simple&threshold=53&sort=0"
    }
    urls[key]
  end

end

#
# => Need to fix ArScrape.
# => Also need to add href values into an array. Plus helper methods
# => Refractor code so methods are in super class. q
#
#      
class ArSearch < PageSearch
  
  def initialize(str)
    @@results = {}
    search_results(str)
  end

  # Uses a nokogiri method .css
  def search_results(str)
    data = get_data(search(str)).css('.resultTitle a')[0..4]
    to_clean_results(data)
  end

  # Results are to a Hash
  def to_clean_results(data)
    data.each do |element| 
      title = element.text.strip 
      @@results[title] = element[:href]
    end
  end

  def search_url
    url("ar")
  end

  def results
    @@results
  end

end

class CoSearch < PageSearch
  
  def initialize(str)
    @@results = {}
    search_results(str)
  end

  def search_results(str)
    data = get_data(search(str)).css('.regular a')[0..4]   
    to_clean_results(data)
  end
  
  def to_clean_results(data)
    data.each do |element| 
      title = element.text.gsub!(/\s+/, " ").downcase.capitalize 
      link = 'http://www.cooks.com' + element[:href]
      @@results[title] = link
    end
  end


  def search_url
    url('co')
  end

  def results
    @@results
  end

end

class EpSearch < PageSearch

  def initialize(str)
    @@results = {}
    search_results(str)
  end

  
  def search_results(str)
    data = get_data(search(str)).css('.sr_rows')[0..4]
    to_clean_results(data)
  end

  def to_clean_results(data)
    data.each do |element| 
      title = element.text.gsub!(/\s+/, " ").split(",")[0]
      link = 'http://www.epicurious.com' + element.at_css('a')[:href]
      @@results[title] = link
    end
  end

  def search_url
    url("ep")
  end

  def results
    @@results
  end

end





