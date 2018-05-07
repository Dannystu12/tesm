require_relative '../db/sql_runner'

class Item
  attr_reader :id
  attr_accessor :name, :description, :buy_price, :sell_price, :school_id, :supplier_id

  def initialize options
    @id = options["id"].to_i if options["id"]
    @name = options["name"]
    @description = options["description"]
    @buy_price = options["buy_price"].to_i
    @sell_price = options["sell_price"].to_i
    @school_id = options["school_id"].to_i
    @supplier_id = options["supplier_id"].to_i
  end

  def create
    sql = "INSERT INTO
    items(name, description, buy_price, sell_price, school_id, supplier_id)
    VALUES($1, $2, $3, $4, $5, $6) RETURNING id"
    values = [@name, @description, @buy_price, @sell_price, @school_id, @supplier_id]
    result = SqlRunner.run sql, values
    @id = result[0]["id"].to_i
  end

  def self.delete_all
    sql = "DELETE FROM items"
    SqlRunner.run sql
  end

  private
  def self.build_results results, type=self
    results.map{|hash| type.new(hash)}
  end
end
