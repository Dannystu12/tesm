require_relative '../models/inventory'
require_relative '../models/item'
require_relative '../models/school'
require_relative '../models/supplier'
require_relative 'uesp_scraper'


Inventory.delete_all
Item.delete_all
School.delete_all
Supplier.delete_all

# ferise_varo = Supplier.new({"name" => "Ferise Varo"})
ferise_varo = Supplier.new(UespScraper.scrape_supplier("http://en.uesp.net/wiki/Morrowind:Ferise_Varo"))
ferise_varo.create

orrent_geontene = Supplier.new(UespScraper.scrape_supplier("http://en.uesp.net/wiki/Morrowind:Orrent_Geontene"))
orrent_geontene.create

# destruction = School.new({
#   "name" => "Destruction",
#   "description" =>"The Destruction skill is the mastery of the spell effects of the College of Destruction. Their spells harm living and unliving things, and include elemental damage, draining, damaging, vulnerability, and disintegration magical effects.",
#   "icon_url" => "http://en.uesp.net/wiki/File:MW-icon-skill-Destruction.jpg"
#   })
# destruction = School.new(UespScraper.scrape_school("http://en.uesp.net/wiki/Morrowind:Destruction"))
# destruction.create

schools = UespScraper.scrape_schools().map{|hash| School.new(hash)}
schools.map{|school| school.create}

spell_hashes = UespScraper.scrape_spells 'http://en.uesp.net/wiki/Morrowind:Ferise_Varo'

spell_hashes.each{ |spell_hash|
  spell_hash["school_id"] = schools.select{|school| school.name == spell_hash["school"]}[0].id
  spell_hash["supplier_id"] = ferise_varo.id
  spell_hash["buy_price"] = spell_hash["sell_price"] / 2

  item = Item.new spell_hash
  item.create
  Inventory.new({
    "item_id" => item.id,
    "quantity" => rand(10)
    }).create
}

#
#
# fireball = Item.new({
#   "name" => "Fireball",
#   "description" => "Fire Damage – 2–20 points instantly in a 5-foot radius on target.",
#   "buy_price" => "2",
#   "sell_price" => "5",
#   "school_id" => schools.select{|school| school.name == "Destruction"}[0].id,
#   "supplier_id" => ferise_varo.id
#   })
# fireball.create
#
# fireball_inventory = Inventory.new({
#   "item_id" => fireball.id,
#   "quantity" => "3"
#   })
# fireball_inventory.create
