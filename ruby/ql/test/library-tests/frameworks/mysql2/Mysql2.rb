class UsersController < ActionController::Base
  def mysql2_handler(event:, context:)
    name = params[:user_name]

    conn = Mysql2::Client.new(
        host: "127.0.0.1",
        username: "root"
    )
    # GOOD: SQL statement is not constructed from user input
    results1 = conn.query("SELECT * FROM users")

    # BAD: SQL statement constructed from user input
    results2 = conn.query("SELECT * FROM users WHERE username='#{name}'")

    # GOOD: user input is escaped
    escaped = Mysql2::Client.escape(name)
    results3 = conn.query("SELECT * FROM users WHERE username='#{escaped}'")

    # GOOD: user input is escaped
    statement1 = conn.prepare("SELECT * FROM users WHERE id >= ? AND username = ?")
    results4 = statement1.execute(1, name, :as => :array)

    # BAD: SQL statement constructed from user input
    statement2 = conn.prepare("SELECT * FROM users WHERE username='#{name}' AND password = ?")
    results4 = statement2.execute("password", :as => :array)

    # NOT EXECUTED
    statement3 = conn.prepare("SELECT * FROM users WHERE username = ?")
  end
end