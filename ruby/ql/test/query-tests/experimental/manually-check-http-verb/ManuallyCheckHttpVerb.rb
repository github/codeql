class ExampleController < ActionController::Base
  # Should find
  def example_action
    if request.get?
      Resource.find(id: params[:example_id])
    end
  end

  # Should find
  def other_action
    if request.env['REQUEST_METHOD'] == "GET"
      Resource.find(id: params[:id])
    end
  end

  # Should find
  def foo
    if request.request_method == "GET"
      Resource.find(id: params[:id])
    end
  end

  # Should find
  def bar
    if request.method == "GET"
      Resource.find(id: params[:id])
    end
  end

  # Should find
  def baz
    if request.raw_request_method == "GET"
      Resource.find(id: params[:id])
    end
  end

    # Should find
    def foobarbaz
      if request.request_method_symbol == :GET
        Resource.find(id: params[:id])
      end
    end

  # Should find
  def resource_action
    case request.env['REQUEST_METHOD']
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