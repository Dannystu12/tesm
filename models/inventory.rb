require_relative '../db/sql_runner'
require_relative 'item'

class Inventory
  attr_reader :id
  attr_accessor :item_id, :quantity

  LOW_STOCK = 3

  def initialize options
    @id = options["id"].to_i if options["id"]
    @item_id = options["item_id"].to_i
    @quantity = options["quantity"].to_i
  end

  def create
    sql = "INSERT INTO inventory(item_id, quantity) VALUES($1, $2) RETURNING id"
    result = SqlRunner.run sql, [@item_id, @quantity]
    @id = result[0]["id"].to_i
  end

  def update
    sql = "UPDATE inventory SET(item_id, quantity) = ($1, $2)
    WHERE id = $3"
    SqlRunner.run sql, [@item_id, @quantity, @id]
  end

  def delete
    sql = "DELETE FROM inventory WHERE id = $1"
    SqlRunner.run sql, [@id]
  end

  def read_item
    Item.read_by_id @item_id
  end

  def increase_qty amount
    return unless amount >= 0
    @quantity += amount
  end

  def decrease_qty amount
    return unless amount >= 0
    return unless @quantity - amount>= 0
    @quantity -= amount
  end

  def low_stock?
    @quantity <= LOW_STOCK
  end

  def out_of_stock?
    @quantity <= 0
  end

  def self.read_by_item item
    sql = "SELECT * FROM inventory WHERE item_id = $1"
    result = SqlRunner.run sql, [item.id]
    build_results(result).first
  end

  def self.read_by_school id
    sql = "SELECT inventory.*
    FROM inventory INNER JOIN items ON inventory.item_id = items.id
    INNER JOIN schools ON items.school_id = schools.id
    WHERE schools.id = $1
    ORDER BY inventory.quantity ASC"
    results = SqlRunner.run sql, [id]
    build_results results
  end

  def self.read_by_supplier id
    sql = "SELECT inventory.*
    FROM inventory INNER JOIN items ON inventory.item_id = items.id
    WHERE items.supplier_id = $1
    ORDER BY inventory.quantity ASC"
    results = SqlRunner.run sql, [id]
    build_results results
  end

  def self.read_all
    sql = "SELECT * FROM inventory ORDER BY quantity ASC"
    results = SqlRunner.run sql
    build_results results
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
