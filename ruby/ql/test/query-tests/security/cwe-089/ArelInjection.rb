
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

    # Headers and cookies blocks for DSL testing
    headers do
      requires :Authorization, type: String
    end

    cookies do
      requires :session_id, type: String
    end

    get '/comprehensive_test/:user_id' do
      # BAD: Comprehensive test using all Grape input sources in one SQL query
      user_id = params[:user_id]           # params taint source
      route_id = route_param(:user_id)     # route_param taint source
      auth = headers[:Authorization]       # headers taint source
      session = cookies[:session_id]       # cookies taint source
      body_data = request.body.read        # request taint source

      # All sources flow to SQL injection
      Arel.sql("SELECT * FROM users WHERE id = #{user_id} AND route_id = #{route_id} AND auth = #{auth} AND session = #{session} AND data = #{body_data}")
    end

    get '/helper_test' do
      # BAD: Test helper method dataflow
      user_id = params[:user_id]
      vulnerable_helper(user_id)
    end

    # Test route_param block pattern
    route_param :id do
      get do
        # BAD: params[:id] should be user input from the path
        user_id = params[:id]
        Arel.sql("SELECT * FROM users WHERE id = #{user_id}")
      end
    end
  end