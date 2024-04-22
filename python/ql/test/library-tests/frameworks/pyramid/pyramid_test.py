from pyramid.view import view_config
from pyramid.config import Configurator

@view_config(route_name="test1")
def test1(request):
    ensure_tainted(
        request,                   # $ tainted

        request.accept,            # $ tainted
        request.accept_charset,    # $ tainted
        request.accept_encoding,   # $ tainted
        request.accept_language,   # $ tainted
        request.authorization,     # $ tainted
        request.cache_control,     # $ tainted
        request.client_addr,       # $ tainted
        request.content_type,      # $ tainted
        request.domain,            # $ tainted
        request.host,              # $ tainted
        request.host_port,         # $ tainted
        request.host_url,          # $ tainted
        request.if_match,          # $ tainted
        request.if_none_match,     # $ tainted
        request.if_range,          # $ tainted   
        request.pragma,            # $ tainted
        request.range,             # $ tainted
        request.referer,           # $ tainted
        request.referrer,          # $ tainted
        request.user_agent,        # $ tainted

        request.as_bytes,          # $ tainted

        request.body,              # $ tainted
        request.body_file,         # $ tainted
        request.body_file_raw,     # $ tainted
        request.body_file_seekable,# $ tainted
        request.body_file.read(),  # $ MISSING:tainted

        request.json,              # $ tainted
        request.json_body,         # $ tainted
        request.json['a']['b'][0]['c'],   # $ tainted

        request.text,               # $ tainted

        request.path,               # $ tainted
        request.path_info,          # $ tainted
        request.path_info_peek(),   # $ tainted
        request.path_info_pop(),    # $ tainted
        request.path_qs,            # $ tainted
        request.path_url,           # $ tainted
        request.query_string,       # $ tainted

        request.url,                # $ tainted
        request.urlargs,            # $ tainted
        request.urlvars,            # $ tainted

        request.GET['a'],           # $ tainted
        request.POST['b'],          # $ tainted
        request.cookies['c'],       # $ tainted
        request.params['d'],        # $ tainted
        request.headers['X-My-Header'],   # $ tainted
        request.GET.values(),       # $ tainted

        request.copy(),             # $ tainted
        request.copy_body(),        # $ tainted
        request.copy_get(),         # $ tainted
        request.copy().GET['a']     # $ MISSING:tainted
        ) 

def test2(request):
    ensure_tainted(request) # $ tainted

@view_config(route_name="test1")
def test3(context, request):
    ensure_tainted(request) # $ tainted

if __name__ == "__main__":
    with Configurator() as config:
        config.add_view(test2, route_name="test2")