require_relative '../db/sql_runner'
require_relative 'school'

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

  def update
    sql = "UPDATE items
    SET(name, description, buy_price, sell_price, school_id, supplier_id)
    = ($1, $2, $3, $4, $5, $6) WHERE id = $7"
    values = [@name, @description, @buy_price, @sell_price, @school_id, @supplier_id, @id]
    SqlRunner.run sql, values
  end

  def delete
    sql = "DELETE FROM items WHERE id = $1"
    SqlRunner.run sql, [@id]
  end

  def read_school
    School.read_by_id @school_id
  end

  def self.read_by_id id
    sql = "SELECT * FROM items WHERE id = $1"
    result = SqlRunner.run sql, [id]
    build_results(result).first
  end

  def self.read_all
    sql = "SELECT * FROM items"
    results = SqlRunner.run sql
    build_results results
  end

  def self.read_by_school school
    sql = "SELECT * FROM items WHERE school_id = $1"
    results = SqlRunner.run sql, [school.id]
    build_results(results)
  end

  def self.read_by_supplier supplier
    sql = "SELECT * FROM items WHERE supplier_id = $1"
    results = SqlRunner.run sql, [supplier.id]
    build_results(results)
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
