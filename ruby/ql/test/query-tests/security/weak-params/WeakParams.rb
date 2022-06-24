class TestController < ActionController::Base
  def create
    TestObject.new(request.request_parameters)
  end

  def create_query
    TestObject.new(request.query_parameters)
  end

  def update
    TestObect.update(object_params)
  end

  # 
  def object_params
    params.require(:uuid).permit(:notes)
  end
end