require 'net/ldap'

class GoodLdapController < ActionController::Base
  def ldap_handler
    name = params[:user_name]
    ldap = Net::LDAP.new(
        host: 'ldap.example.com',
        port: 636,
        encryption: :simple_tls,
        auth: {
            method: :simple,
            username: 'uid=admin,dc=example,dc=com',
            password: 'adminpassword'
        }
    )
    
    name = if ["admin", "guest"].include? name
      name
    else 
      name = "none"
    end

    filter = Net::LDAP::Filter.eq('foo', name)
    attrs = ['dn']
    result = ldap.search(base: 'ou=people,dc=example,dc=com', filter: filter, attributes: attrs)
  end
end
