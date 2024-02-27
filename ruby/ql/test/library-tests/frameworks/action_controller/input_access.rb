class UsersController < ActionController::Base
  def index
    request.params
    request.parameters
    request["parameter_name"]
    request.GET
    request.POST
    request.query_parameters
    request.request_parameters
    request.filtered_parameters
    request.query_string

    request.authorization
    request.script_name
    request.path_info
    request.user_agent
    request.referer
    request.referrer
    request.headers
    request.cookies
    request.cookie_jar
    request.content_type
    request.accept
    request.accept_encoding
    request.accept_language
    request.if_none_match
    request.if_none_match_etags
    request.content_mime_type

    request.authority
    request.host
    request.host_authority
    request.host_with_port
    request.raw_host_with_port
    request.hostname
    request.forwarded_for
    request.forwarded_host
    request.port
    request.forwarded_port
    request.port_string
    request.domain
    request.subdomain
    request.subdomains

    request.media_type
    request.media_type_params
    request.content_charset
    request.base_url

    request.body
    request.raw_post

    request.env["HTTP_ACCEPT"]
    request.env["NOT_USER_CONTROLLED"]
    request.filtered_env["HTTP_ACCEPT"]
    request.filtered_env["NOT_USER_CONTROLLED"]
  end
end
