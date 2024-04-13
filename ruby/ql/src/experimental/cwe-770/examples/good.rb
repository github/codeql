class UserController < ActionController::Base
    def good_example
      limit = params[:limit].to_i

      # limit the limit between 1 and 1000
      if not (limit => 1 && limit < 1000)
         limit = 10
      end 
      

      # repeat a simple operation for the number of limit specified using upto()
      1.upto(days) do |i|
          put "a repeatable operation"
      end
  
    end
  end