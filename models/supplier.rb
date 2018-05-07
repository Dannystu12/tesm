require_relative '../db/sql_runner'

class Supplier

  attr_reader :id
  attr_accessor :name

  def initialize options
    @id = options["id"].to_i if options["id"]
    @name = options["name"]
  end

  def create
    sql = "INSERT INTO suppliers(name)
    VALUES($1) RETURNING id"
    result = SqlRunner.run sql, [@name]
    @id = result[0]["id"].to_i
  end

  def self.delete_all
    sql = "DELETE FROM suppliers"
    SqlRunner.run sql
  end

  private
  def self.build_results results, type=self
    results.map{|hash| type.new(hash)}
  end
end
