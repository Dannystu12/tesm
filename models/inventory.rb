require_relative '../db/sql_runner'

class Inventory
  attr_reader :id
  attr_accessor :item_id, :quantity
  
  def initialize options
    @id = options["id"].to_i if options["id"]
    @item_id = options["item_id"].to_i
    @quantity = options["quantity"].to_i
  end

  def self.delete_all
    sql = "DELETE FROM inventory"
    SqlRunner.run sql
  end

  private
  def self.build_results results, type=self
    results.map{|hash| type.new(hash)}
  end
end
