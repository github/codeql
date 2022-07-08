# There should be no hits from this class because it does not inherit from ActionController
class NotAController
  def example_action
    if request.get?
      Example.find(params[:example_id])
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