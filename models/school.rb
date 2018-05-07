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

  def self.delete_all
    sql = "DELETE FROM schools"
    SqlRunner.run sql
  end

  private
  def self.build_results results, type=self
    results.map{|hash| type.new(hash)}
  end
end
