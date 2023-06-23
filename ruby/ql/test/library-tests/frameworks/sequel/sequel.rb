require 'sequel'

class UsersController < ActionController::Base
    def sequel_handler(event:, context:)
        name = params[:name]
        conn = Sequel.sqlite("sqlite://example.db")

        # BAD: SQL statement constructed from user input
        conn["SELECT * FROM users WHERE username='#{name}'"]

        # BAD: SQL statement constructed from user input
        conn.run("SELECT * FROM users WHERE username='#{name}'")

        # BAD: SQL statement constructed from user input
        conn.fetch("SELECT * FROM users WHERE username='#{name}'") do |row|
            puts row[:name]
        end

        # GOOD: SQL statement is not constructed from user input
        conn["SELECT * FROM users WHERE username='im_not_input'"]

        # BAD: SQL statement constructed from user input
        conn.execute "SELECT * FROM users WHERE username=#{name}"

        # BAD: SQL statement constructed from user input
        conn.execute_ddl "SELECT * FROM users WHERE username='#{name}'"

        # BAD: SQL statement constructed from user input
        conn.execute_dui "SELECT * FROM users WHERE username='#{name}'"

        # BAD: SQL statement constructed from user input
        conn.execute_insert "SELECT * FROM users WHERE username='#{name}'"

        # BAD: SQL statement constructed from user input
        conn << "SELECT * FROM users WHERE username='#{name}'"

        # BAD: SQL statement constructed from user input
        conn.fetch_rows("SELECT * FROM users WHERE username='#{name}'"){|row| }

        # BAD: SQL statement constructed from user input
        conn.dataset.with_sql_all("SELECT * FROM users WHERE username='#{name}'")

        # BAD: SQL statement constructed from user input
        conn.dataset.with_sql_delete("SELECT * FROM users WHERE username='#{name}'")

        # BAD: SQL statement constructed from user input
        conn.dataset.with_sql_each("SELECT * FROM users WHERE username='#{name}'"){|row| }

        # BAD: SQL statement constructed from user input
        conn.dataset.with_sql_first("SELECT * FROM users WHERE username='#{name}'")

        # BAD: SQL statement constructed from user input
        conn.dataset.with_sql_insert("SELECT * FROM users WHERE username='#{name}'")

        # BAD: SQL statement constructed from user input
        conn.dataset.with_sql_single_value("SELECT * FROM users WHERE username='#{name}'")

        # BAD: SQL statement constructed from user input
        conn.dataset.with_sql_update("SELECT * FROM users WHERE username='#{name}'")

        # BAD: SQL statement constructed from user input
        conn[:table].select(Sequel.cast(:a, name)) 

        # BAD: SQL statement constructed from user input
        conn[:table].select(Sequel.function(name)) 
    end
end