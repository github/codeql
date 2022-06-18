class TestController < ActionController::Base
  def create
    TestObject.new(request.request_parameters)
  end

  def create_query
    TestObject.new(request.query_parameters)
  end

  # 
  def object_params
    p = params.query_parameters
    params.require(:uuid).permit(:notes)
  end
end