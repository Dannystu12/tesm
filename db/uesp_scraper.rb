require 'open-uri'
require 'nokogiri'

class UespScraper
  BASE_URL = "http://en.uesp.net"
  MAGIC_SCHOOLS_URL = "/wiki/Morrowind:Magic"

  def self.scrape_supplier url
    doc = get_doc url
    name = doc.css('#firstHeading').first.text
    name.slice!("Morrowind:")

    location = doc.css('.wikitable tr td')[1].text

    image_url = doc.css('div.thumbinner img').first['src']
    {"name" => name, "location" => location, "image_url" => image_url}
  end

  def self.scrape_school url
    doc = get_doc url
    name = doc.css('#firstHeading').first.text
    name.slice! "Morrowind:"

    description1 = doc.css('#mw-content-text > p')[0].text
    description2 = doc.css('#mw-content-text > p')[1].text
    description = "#{description1}#{description1 == "" ? "" : "\n"}#{description2}"

    icon_url = doc.css('.wikitable img:first-child').first['src']
    {"name" => name, "description" => description, "icon_url" => icon_url}
  end

  def self.scrape_schools
    school_count = 6
    result = []
    doc = get_doc(BASE_URL + MAGIC_SCHOOLS_URL)
    doc.css('#mw-content-text > ul > li').each_with_index{|li, i|
      break if i >= school_count
      school_url = li.css('a').first['href']
      school_hash = scrape_school(BASE_URL + school_url)
      result.push(school_hash)
    }
    result
  end

  private
  def self.get_doc url
    html = open(url)
    Nokogiri::HTML(html)
  end
end
