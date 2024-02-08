class BazController < ActionController::Base
    def index
        client = Mysql2::Client.new
        client.query(params[:query])

        client = Mysql2::EM::Client.new
        client.prepare(params[:query])
    end
end