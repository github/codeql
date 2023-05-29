class FooController < ActionController::Base
  def some_request_handler
    pass = params[:pass]
    ldap = Net::LDAP.new(
        host: 'ldap.example.com',
        port: 636,
        encryption: :simple_tls,
        auth: {
            method: :simple,
            username: 'uid=admin,dc=example,dc=com',
            password: pass
        }
    )
    ldap.bind
  end
end