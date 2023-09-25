class FooController < ActionController::Base
  def some_request_handler
    # A string tainted by user input is used directly as password
    # (i.e a remote flow source)
    pass = params[:pass]

    # BAD: user input is not sanitized
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

  def some_request_handler
    # A string tainted by user input is used directly as password
    # (i.e a remote flow source)
    pass = params[:pass]

    # BAD: user input is not sanitized
    ldap = Net::LDAP.new
    ldap.host = your_server_ip_address
    ldap.encryption(:method => :simple_tls)
    ldap.port = 639
    ldap.auth "admin", pass
    ldap.bind
  end
end

class BarController < ApplicationController
  def safe_paths
    pass = params[:pass]

    # GOOD: barrier guard prevents taint flow
    if password.nil? || password.empty?
      # protect against passwordless auth from ldap server
      pass = "$uper$secure123"
    else
      pass
    end

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
  end
end