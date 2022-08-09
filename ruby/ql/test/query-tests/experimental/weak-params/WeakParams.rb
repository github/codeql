class TestController < ActionController::Base
  
  # Should catch
  def create
    TestObject.create(foo: request.request_parameters[:foo])
  end

  # Should catch
  def create_query
    TestObject.create(foo: request.query_parameters[:foo])
  end

  # Should catch
  def update_unsafe
    TestObject.update(foo: request.POST[:foo])
  end

  # Should catch
  def update_unsafe_get
    TestObject.update(foo: request.GET[:foo])
  end

  # Should not catch
  def update
    TestObject.update(object_params)
  end

  # strong params method
  def object_params
    params.require(:uuid).permit(:notes)
  end

  # Should not catch
  def test_non_sink
    puts request.request_parameters
  end
end

class TestObject < ActiveRecord::Base
end