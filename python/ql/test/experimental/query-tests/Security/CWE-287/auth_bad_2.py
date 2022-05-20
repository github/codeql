from flask import request, Flask
import ldap
import ldap.filter
import ldap.dn

app = Flask(__name__)


@app.route("/simple_bind_example")
def simple_bind_example():
    """
    The bind's password argument is not set
    """

    dn = "dc={}".format(ldap.dn.escape_dn_chars(request.args['dc']))
    search_filter = "(user={})".format(ldap.filter.escape_filter_chars(request.args['search']))

    ldap_connection = ldap.initialize("ldap://127.0.0.1:1337")
    ldap_connection.simple_bind('cn=root')
    user = ldap_connection.search_s(dn, ldap.SCOPE_SUBTREE, search_filter)


@app.route("/simple_bind_s_example")
def simple_bind_s_example():
    """
    The bind's password argument is not set
    """

    dn = "dc={}".format(ldap.dn.escape_dn_chars(request.args['dc']))
    search_filter = "(user={})".format(ldap.filter.escape_filter_chars(request.args['search']))

    ldap_connection = ldap.initialize("ldap://127.0.0.1:1337")
    ldap_connection.simple_bind_s('cn=root')
    user = ldap_connection.search_s(dn, ldap.SCOPE_SUBTREE, search_filter)


@app.route("/bind_s_example")
def bind_s_example():
    """
    The bind's password argument is set to None
    """

    dn = "dc={}".format(ldap.dn.escape_dn_chars(request.args['dc']))
    search_filter = "(user={})".format(ldap.filter.escape_filter_chars(request.args['search']))

    ldap_connection = ldap.initialize("ldap://127.0.0.1:1337")
    ldap_connection.bind_s('cn=root', None)
    user = ldap_connection.search_s(dn, ldap.SCOPE_SUBTREE, search_filter)

@app.route("/bind_s_example")
def bind_s_example_kwargs():
    """
    The bind's password argument is set to None
    """

    dn = "dc={}".format(ldap.dn.escape_dn_chars(request.args['dc']))
    search_filter = "(user={})".format(ldap.filter.escape_filter_chars(request.args['search']))

    ldap_connection = ldap.initialize("ldap://127.0.0.1:1337")
    ldap_connection.bind_s(who='cn=root', cred=None)
    user = ldap_connection.search_s(dn, ldap.SCOPE_SUBTREE, search_filter)

@app.route("/bind_example")
def bind_example():
    """
    The bind's password argument is an empty string
    """

    dn = "dc={}".format(ldap.dn.escape_dn_chars(request.args['dc']))
    search_filter = "(user={})".format(ldap.filter.escape_filter_chars(request.args['search']))

    ldap_connection = ldap.initialize("ldap://127.0.0.1:1337")
    ldap_connection.bind('cn=root', "")
    user = ldap_connection.search_s(dn, ldap.SCOPE_SUBTREE, search_filter)


@app.route("/bind_example")
def bind_example():
    """
    The bind's password argument is an empty string
    """

    dn = "dc={}".format(ldap.dn.escape_dn_chars(request.args['dc']))
    search_filter = "(user={})".format(ldap.filter.escape_filter_chars(request.args['search']))

    ldap_connection = ldap.initialize("ldap://127.0.0.1:1337")
    ldap_connection.bind(who='cn=root', cred="")
    user = ldap_connection.search_s(dn, ldap.SCOPE_SUBTREE, search_filter)


# if __name__ == "__main__":
#     app.run(debug=True)
