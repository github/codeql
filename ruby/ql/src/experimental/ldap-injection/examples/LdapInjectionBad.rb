require 'net/ldap'

class BadLdapController < ActionController::Base
  def ldap_handler
    name = params[:user_name]
    dc = params[:dc]
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
    filter = Net::LDAP::Filter.eq('foo', name)
    attrs = [name]
    result = ldap.search(base: "ou=people,dc=#{dc},dc=com", filter: filter, attributes: attrs)
  end
end
