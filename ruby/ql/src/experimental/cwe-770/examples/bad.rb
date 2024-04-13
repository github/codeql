class UserController < ActionController::Base
  def bad_examples
    limit = params[:limit].to_i
    
    # repeat a simple operation for the number of limit specified using upto()
    1.upto(days) do |i|
        put "a repeatable operation"
    end
    
    # repeat a simple operation for the number of limit specified using times()
    limit.times do
        put "a repeatable operation"
    end

    # repeat a simple operation for the number of limit specified using downto()
    limit.downto(1) do |i|
        put "a repeatable operation"
    end

  end
end