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

  def update
    sql = "UPDATE suppliers SET name = $1"
    SqlRunner.run sql, [@name]
  end

  def delete
    sql = "DELETE FROM suppliers WHERE id = $1"
    SqlRunner.run sql, [@id]
  end

  def self.read_by_id id
    sql = "SELECT * FROM suppliers WHERE id = $1"
    result = SqlRunner.run sql, [id]
    build_results(result).first
  end

  def self.read_all
    sql = "SELECT * FROM suppliers"
    results = SqlRunner.run sql
    build_results(results)
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
