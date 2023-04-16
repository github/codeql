require 'sqlite3'

db = SQLite3::Database.new "test.db"

db.execute <<-SQL
  create table numbers (
    name varchar(30),
    val int
  );
SQL

stmt = db.prepare "select * from numbers"

stmt.execute

SQLite3::Database.new( "data.db" ) do |db|
  db.execute( "select * from table" ) do |row|
    p row
  end
end
