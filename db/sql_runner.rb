require 'pg'

class SqlRunner
  DB = 'tesm'
  def self.run sql, values=[]
    begin
      db = PG.connect({dbname: DB, host: 'localhost'})
      db.prepare 'query', sql
      results = db.exec_prepared 'query', values
    ensure
      db.close if db
    end
    results
  end
end
