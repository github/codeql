
class PotatoController < ActionController::Base
  def unsafe_action
    name = params[:user_name]
    # BAD: SQL statement constructed from user input
    sql = Arel.sql("SELECT * FROM users WHERE name = #{name}")
    sql = Arel::Nodes::SqlLiteral.new("SELECT * FROM users WHERE name = #{name}")
  end
end