class ExampleController < ActionController::Base
  # Should find
  def example_action
    if request.get? # $ Alert
      Resource.find(id: params[:example_id])
    end
  end

  # Should find
  def other_action
    method = request.env['REQUEST_METHOD'] # $ Source
    if method == "GET" # $ Alert
      Resource.find(id: params[:id])
    end
  end

  # Should find
  def foo
    method = request.request_method # $ Source
    if method == "GET" # $ Alert
      Resource.find(id: params[:id])
    end
  end

  # Should find
  def bar
    method = request.method # $ Source
    if method == "GET" # $ Alert
      Resource.find(id: params[:id])
    end
  end

  # Should find
  def baz
    method = request.raw_request_method # $ Source
    if method == "GET" # $ Alert
      Resource.find(id: params[:id])
    end
  end

  # Should not find
  def baz2
    method = request.raw_request_method
    if some_other_function == "GET"
      Resource.find(id: params[:id])
    end
  end

    # Should find
    def foobarbaz
      method = request.request_method_symbol # $ Source
      if method == :GET # $ Alert
        Resource.find(id: params[:id])
      end
    end

  # Should find
  def resource_action
    case request.env['REQUEST_METHOD'] # $ Alert
    when "GET"
      Resource.find(id: params[:id])
    when "POST"
      Resource.new(id: params[:id], details: params[:details])
    end
  end

  # Should not find
  def resource_action
    case request.random_method
    when "GET"
      Resource.find(id: params[:id])
    when "POST"
      Resource.new(id: params[:id], details: params[:details])
    end
  end
end

class SafeController < ActionController::Base
  # this class should have no hits because controllers rely on conventional Rails routes
  def index
    Resource.find(id: params[:id])
  end

  def create
    Resource.new(id: params[:id], details: params[:details])
  end

  def update
    Resource.update(id: params[:id], details: params[:details])
  end

  def delete
    s = Resource.find(id: params[:id])
    s.delete
  end
end

# There should be no hits from this class because it does not inherit from ActionController
class NotAController
  def example_action
    if request.get?
      Resource.find(params[:example_id])
    end
  end

  def resource_action
    case env['REQUEST_METHOD']
    when "GET"
      Resource.find(params[:id])
    when "POST"
      Resource.new(params[:id], params[:details])
    end
  end
end

class Resource < ActiveRecord::Base
end
