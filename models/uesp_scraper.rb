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

  def self.scrape_spells url
    doc = get_doc url
    spell_table = doc.search('table.wikitable').last
    cells = []
    spell_table.search('tr').each {|tr|
      cells.push(tr.search('th, td'))
    }
    #remove header cells
    cells.shift 1
    school = ""
    results = []

    cells.each{ |cell|
      if cell.attr('colspan')
        school = cell.text
        next
      end

      name = cell.children[0].text
      cost = cell.children[1].text.to_i
      desc = cell.children[4].text + cell.children[5].text
      results.push({"school" => school, "name" => name, "sell_price" => cost, "description" => desc})
    }
    results
  end

  private
  def self.get_doc url
    html = open(url)
    Nokogiri::HTML(html)
  end
end
