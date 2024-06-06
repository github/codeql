class FooController < ActionController::Base
  def some_request_handler
    # A string tainted by user input is used directly as DN
    # (i.e a remote flow source)
    dc = params[:dc]

    # A string tainted by user input is used directly as search filter or attribute
    # (i.e a remote flow source)
    name = params[:user_name]

    # LDAP Connection
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

    # BAD: user input is used as DN 
    # where dc is unsanitized
    ldap.search(base: "ou=people,dc=#{dc},dc=com", filter: "cn=George", attributes: [""])

    # BAD: user input is used as search filter
    # where name is unsanitized
    ldap.search(base: "ou=people,dc=example,dc=com", filter: "cn=#{name}", attributes: [""])

    # BAD: user input is used as attribute
    # where name is unsanitized
    ldap.search(base: "ou=people,dc=example,dc=com", filter: "cn=George", attributes: [name])

    # BAD: user input is used as search filter
    # where name is unsanitized
    filter = Net::LDAP::Filter.eq('cn', name)
    ldap.search(base: "ou=people,dc=example,dc=com", filter: filter, attributes: [""])

    # GOOD: user input is not used in the LDAP query
    result = ldap.search(base: "ou=people,dc=example,dc=com", filter: "cn=George", attributes: [""])
  end
end

class BarController < ApplicationController
  def safe_paths
    dc = params[:dc]
    # GOOD: barrier guard prevents taint flow
    if dc == "example"
      base = "ou=people,dc=#{dc},dc=com"
    else
      base = "ou=people,dc=default,dc=com"
    end
    ldap.search(base: base, filter: "cn=George", attributes: [""])


    name = params[:user_name]
    # GOOD: barrier guard prevents taint flow
    name = if ["George", "Nicolas"].include? name
      name
    else 
      name = "Guest"
    end
    result = ldap.search(base: "ou=people,dc=example,dc=com", filter: "cn=#{name}", attributes: [""])
  end
end