require_relative '../db/sql_runner'

class Supplier
  def self.delete_all
    sql = "DELETE FROM suppliers"
    SqlRunner.run sql
  end

  def self.build_results results, type=self
    results.map{|hash| type.new(hash)}
  end
end
