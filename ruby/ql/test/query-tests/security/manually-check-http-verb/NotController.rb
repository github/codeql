# There should be no hits from this class because it does not inherit from ActionController
class NotAController
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

  def resource_action
    case env['REQUEST_METHOD']
    when "GET"
      Resource.find(params[:id])
    when "POST"
      Resource.new(params[:id], params[:details])
    end
  end
end