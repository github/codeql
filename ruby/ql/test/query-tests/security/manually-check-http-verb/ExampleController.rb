class ExampleController < ActionController::Base
  # This function should have 6 vulnerable lines
  def example_action
    if request.get?
      Example.find(params[:example_id])
    elsif request.post?
      Example.new(params[:example_name], params[:example_details])
    elsif request.delete?
      example = Example.find(params[:example_id])
      example.delete
    elsif request.put?
      Example.upsert(params[:example_name], params[:example_details])
    elsif request.path?
      Example.update(params[:example_name], params[:example_details])
    elsif request.head?
      "This is the endpoint for the Example resource."
    end
  end
end

class OtherController < ActionController::Base
  def other_action
    if env['REQUEST_METHOD'] == "GET"
      Other.find(params[:id])
    end
  end
end

class ResourceController < ActionController::Base
    # This method should have 1 vulnerable line, but is currently failing because it's not a comparison node
    def resource_action
      case env['REQUEST_METHOD']
      when "GET"
        Resource.find(params[:id])
      when "POST"
        Resource.new(params[:id], params[:details])
      end
    end
end

class SafeController < ActionController::Base
  # this method should have no hits because controllers rely on conventional Rails routes
  def index
    Safe.find(params[:id])
  end

  def create
    Safe.new(params[:id], params[:details])
  end

  def update
    Safe.update(params[:id], params[:details])
  end

  def delete
    s = Safe.find(params[:id])
    s.delete
  end
end