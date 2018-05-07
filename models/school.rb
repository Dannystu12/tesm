require_relative '../db/sql_runner'

class School
  attr_reader :id
  attr_accessor :name, :description, :icon_url

  def initialize options
    @id = options["id"].to_i if options["id"]
    @name = options["name"]
    @description = options["description"]
    @icon_url = options["icon_url"]
  end

  def create
    sql = "INSERT INTO schools(name, description, icon_url)
    VALUES($1, $2, $3) RETURNING id"
    values = [@name, @description, @icon_url]
    result = SqlRunner.run sql, values
    @id = result[0]["id"].to_i
  end

  def update
    sql = "UPDATE schools SET(name, description, icon_url) = ($1, $2, $3)
    WHERE id = $4"
    SqlRunner.run sql, [@name, @description, @icon_url, @id]
  end

  def delete
    sql = "DELETE FROM schools WHERE id = $1"
    SqlRunner.run sql, [@id]
  end

  def self.read_by_id id
    sql = "SELECT * FROM schools WHERE id = $1"
    result = SqlRunner.run sql, [@id]
    build_results(result).first
  end

  def self.read_all
    sql = "SELECT * FROM schools"
    results = SqlRunner.run sql
    build_results(results)
  end

  def self.delete_all
    sql = "DELETE FROM schools"
    SqlRunner.run sql
  end

  private
  def self.build_results results, type=self
    results.map{|hash| type.new(hash)}
  end
end
