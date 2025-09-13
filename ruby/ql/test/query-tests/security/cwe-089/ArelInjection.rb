
class PotatoController < ActionController::Base
  def unsafe_action
    name = params[:user_name]
    # BAD: SQL statement constructed from user input
    sql = Arel.sql("SELECT * FROM users WHERE name = #{name}")
    sql = Arel::Nodes::SqlLiteral.new("SELECT * FROM users WHERE name = #{name}")
  end
end

class PotatoAPI < Grape::API
  get '/unsafe_endpoint' do
    name = params[:user_name]
    # BAD: SQL statement constructed from user input
    sql = Arel.sql("SELECT * FROM users WHERE name = #{name}")
    sql = Arel::Nodes::SqlLiteral.new("SELECT * FROM users WHERE name = #{name}")
  end
end

class SimpleAPI < Grape::API
  get '/test' do
    x = params[:name]
    Arel.sql("SELECT * FROM users WHERE name = #{x}")
  end
end

  # Test helper method pattern in Grape helpers block
  class TestAPI < Grape::API
    helpers do
      def vulnerable_helper(user_id)
        # BAD: SQL statement constructed from user input passed as parameter
        Arel.sql("SELECT * FROM users WHERE id = #{user_id}")
      end
    end

    get '/helper_test' do
      # This should be detected as SQL injection via helper method
      user_id = params[:user_id]
      vulnerable_helper(user_id)
    end
  end