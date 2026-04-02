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


class SqliteController < ActionController::Base
  def sqlite3_handler
    category = params[:category] # $ Source[rb/sql-injection]
    db = SQLite3::Database.new "test.db"

    # BAD: SQL injection vulnerability
    db.execute("select * from table where category = '#{category}'") # $ Alert[rb/sql-injection]

    # GOOD: Sanitized by SQLite3::Database.quote
    sanitized_category = SQLite3::Database.quote(category)
    db.execute("select * from table where category = '#{sanitized_category}'")
  end
end
