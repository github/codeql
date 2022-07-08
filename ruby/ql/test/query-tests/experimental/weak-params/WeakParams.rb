class TestController < ActionController::Base
  def create
    TestObject.new(request.request_parameters)
  end

  def create_query
    TestObject.new(request.query_parameters)
  end

  def update
    TestObject.update(object_params)
  end

  # 
  def object_params
    params.require(:uuid).permit(:notes)
  end
end