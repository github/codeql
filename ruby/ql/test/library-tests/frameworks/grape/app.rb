class MyAPI < Grape::API
  version 'v1', using: :header, vendor: 'myapi'
  format :json
  prefix :api

  desc 'Simple get endpoint'
  get '/hello/:name' do
    name = params[:name]
    user_agent = headers['User-Agent']
    "Hello #{name}!"
  end

  desc 'Post endpoint with params'
  params do
    requires :message, type: String
  end
  post '/messages' do
    msg = params[:message]
    { status: 'received', message: msg }
  end

  desc 'Put endpoint accessing request'
  put '/update/:id' do
    id = params[:id]
    body = request.body.read
    { id: id, body: body }
  end

  desc 'Delete endpoint'
  delete '/items/:id' do
    params[:id]
  end

  desc 'Patch endpoint'
  patch '/items/:id' do
    params[:id]
  end

  desc 'Head endpoint'
  head '/status' do
    # Just return status
  end

  desc 'Options endpoint'
  options '/info' do
    headers['Access-Control-Allow-Methods'] = 'GET, POST, OPTIONS'
  end

  desc 'Route param endpoint'
  get '/users/:user_id/posts/:post_id' do
    user_id = route_param(:user_id)
    post_id = route_param('post_id')
    { user_id: user_id, post_id: post_id }
  end

  desc 'Route param block pattern'
  route_param :id do
    get do
      # params[:id] is user input from the path parameter
      id = params[:id]
      { id: id }
    end
  end

  # Headers block for defining expected headers
  headers do
    requires :Authorization, type: String
    optional 'X-Custom-Header', type: String
  end

  # Cookies block for defining expected cookies
  cookies do
    requires :session_id, type: String
    optional :tracking_id, type: String
  end

  desc 'Endpoint that uses cookies method'
  get '/cookie_test' do
    session = cookies[:session_id]
    tracking = cookies['tracking_id']
    { session: session, tracking: tracking }
  end

  desc 'Endpoint that uses headers method'
  get '/header_test' do
    auth = headers[:Authorization]
    custom = headers['X-Custom-Header']
    { auth: auth, custom: custom }
  end
end

class AdminAPI < Grape::API
  get '/admin' do
    params[:token]
  end
end

class UserAPI < Grape::API
    VALID_PARAMS = %w(name email password password_confirmation)

    helpers do
        def user_params
            params.select{|key,value| VALID_PARAMS.include?(key.to_s)} # Real helper implementation
        end

        def vulnerable_helper(user_id)
            source "paramHelper" # Test parameter passing to helper
        end

        def simple_helper
            source "simpleHelper" # Test simple helper return
        end

        # Nested helper scenarios that require getParent+()
        module AuthHelpers
            def authenticate_user
                token = params[:token]
                source "nestedModuleHelper" # Test nested module helper
            end

            def check_permissions(resource)
                source "nestedPermissionHelper" # Test nested module helper with params
            end
        end

        class ValidationHelpers
            def self.validate_email(email)
                source "nestedClassHelper" # Test nested class helper
            end
        end

        if Rails.env.development?
            def debug_helper
                source "conditionalHelper" # Test helper inside conditional block
            end
        end

        begin
            def rescue_helper
                source "rescueHelper" # Test helper inside begin block
            end
        rescue
            # error handling
        end

        # Helper inside a case statement
        case ENV['RACK_ENV']
        when 'test'
            def test_helper
                source "caseHelper" # Test helper inside case block
            end
        end
    end

    # Headers and cookies blocks for DSL testing
    headers do
        requires :Authorization, type: String
    end

    cookies do
        requires :session_id, type: String
    end

    get '/comprehensive_test/:user_id' do
        # Test all Grape input sources
        user_id = params[:user_id]           # params taint source
        route_id = route_param(:user_id)     # route_param taint source
        auth = headers[:Authorization]       # headers taint source
        session = cookies[:session_id]       # cookies taint source
        body_data = request.body.read        # request taint source

        # Test sinks for all sources
        sink user_id # $ hasTaintFlow
        sink route_id # $ hasTaintFlow
        sink auth # $ hasTaintFlow
        sink session # $ hasTaintFlow
        # Note: request.body.read may not be detected by this flow test config
    end

    get '/helper_test/:user_id' do
        # Test helper method parameter passing dataflow
        user_id = params[:user_id]
        result = vulnerable_helper(user_id)
        sink result # $ hasValueFlow=paramHelper
    end

    post '/users' do
        # Test helper method return dataflow
        user_data = user_params
        simple_result = simple_helper
        sink user_data # $ hasTaintFlow
        sink simple_result # $ hasValueFlow=simpleHelper
    end

    # Test route_param block pattern
    route_param :id do
        get do
            # params[:id] should be user input from the path
            user_id = params[:id]
            sink user_id # $ hasTaintFlow
        end
    end

    post '/users' do
        user_data = user_params
        sink user_data # $ hasTaintFlow
    end

    # Test nested helper methods
    get '/nested_test/:token' do
        # Test nested module helper
        auth_result = authenticate_user
        sink auth_result # $ hasValueFlow=nestedModuleHelper

        # Test nested module helper with parameters
        perm_result = check_permissions("admin")
        sink perm_result # $ hasValueFlow=nestedPermissionHelper

        # Test nested class helper
        validation_result = ValidationHelpers.validate_email("test@example.com")
        sink validation_result # $ hasValueFlow=nestedClassHelper

        # Test conditional helper (if it exists)
        if respond_to?(:debug_helper)
            debug_result = debug_helper
            sink debug_result # $ hasValueFlow=conditionalHelper
        end

        # Test rescue helper
        rescue_result = rescue_helper
        sink rescue_result # $ hasValueFlow=rescueHelper

        # Test case helper (if it exists)
        if respond_to?(:test_helper)
            case_result = test_helper
            sink case_result # $ hasValueFlow=caseHelper
        end
    end
end
