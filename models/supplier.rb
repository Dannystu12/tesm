require_relative '../db/sql_runner'

class Supplier

  attr_reader :id
  attr_accessor :name
  
  def initialize options
    @id = options["id"].to_i if options["id"]
    @name = options["name"]
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
