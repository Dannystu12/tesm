require 'open-uri'
require 'nokogiri'

class UespScraper
  def self.scrape_supplier url
    doc = get_doc url
    name = doc.css('#firstHeading').first.text
    name.slice!("Morrowind:")
    {"name" => name}
  end

  private
  def self.get_doc url
    html = open(url)
    Nokogiri::HTML(html)
  end
end
