from bottle import route, run, template


# This is not vulnerable, since the default templating engine (SimpleTemplate) performs
# escaping of special HTML characters
@route('/hello/<name>')
def hello(name):
    return template('<b>Hello {{name}}</b>!', name=name)


# This does not allow using a forward slash in `name`, so `<script>alert("oops")</script>`
# does not work (but it is still vulnerable to other XSS)
@route('/xss/<name>')
def xss(name):
    return '<b>Hello {name}</b>!'.format(name=name)


# By specifically allowing ANY character to be captured by `name`, we can cause XSS by using
# `<script>alert("oops")</script>` as `name`.
@route('/easy-xss/<name:re:.*>')
def xss(name):
    return '<b>Hello {name}</b>!'.format(name=name)


run(host='localhost', port=8080, reloader=True)


# After starting the server, visit:
# - http://localhost:8080/hello/world
# - http://localhost:8080/xss/world
# - http://localhost:8080/easy-xss/world
#
# Using malicious `<img src=0 onerror=alert(1)>`:
# - http://localhost:8080/hello/img-pwn%3Cimg%20src=0%20onerror=alert(1)%3E (safe)
# - http://localhost:8080/xss/img-pwn%3Cimg%20src=0%20onerror=alert(1)%3E (vuln)
#
# Using `<script>alert("oops")</script>`:
# - http://localhost:8080/xss/pwned%3Cscript%3Ealert(%22oops%22);%3C/script%3E (404)
# - http://localhost:8080/easy-xss/pwned%3Cscript%3Ealert(%22oops%22);%3C/script%3E (vuln)
