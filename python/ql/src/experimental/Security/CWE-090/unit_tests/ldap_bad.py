from flask import request, Flask
import ldap

app = Flask(__name__)


@app.route("/normal")
def normal():
    unsafe_dn = "dc=%s" % request.args['dc']
    unsafe_filter = "(user=%s)" % request.args['username']

    ldap_connection = ldap.initialize("ldap://127.0.0.1:1337")
    user = ldap_connection.search_s(
        unsafe_dn, ldap.SCOPE_SUBTREE, unsafe_filter, ["testAttr1", "testAttr2"])


@app.route("/normal_noAttrs")
def normal_noAttrs():
    unsafe_dn = "dc=%s" % request.args['dc']
    unsafe_filter = "(user=%s)" % request.args['username']

    ldap_connection = ldap.initialize("ldap://127.0.0.1:1337")
    user = ldap_connection.search_s(
        unsafe_dn, ldap.SCOPE_SUBTREE, unsafe_filter)


@app.route("/direct")
def direct():
    unsafe_dn = "dc=%s" % request.args['dc']
    unsafe_filter = "(user=%s)" % request.args['username']

    user = ldap.initialize("ldap://127.0.0.1:1337").search_s(
        unsafe_dn, ldap.SCOPE_SUBTREE, unsafe_filter, ["testAttr1", "testAttr2"])


@app.route("/normal_argbyname")
def normal_argbyname():
    unsafe_dn = "dc=%s" % request.args['dc']
    unsafe_filter = "(user=%s)" % request.args['username']

    ldap_connection = ldap.initialize("ldap://127.0.0.1:1337")
    user = ldap_connection.search_s(
        unsafe_dn, ldap.SCOPE_SUBTREE, attrlist=["testAttr1", "testAttr2"], filterstr=unsafe_filter)


@app.route("/direct_argbyname")
def direct_argbyname():
    unsafe_dn = "dc=%s" % request.args['dc']
    unsafe_filter = "(user=%s)" % request.args['username']

    user = ldap.initialize("ldap://127.0.0.1:1337").search_s(
        unsafe_dn, ldap.SCOPE_SUBTREE, attrlist=["testAttr1", "testAttr2"], filterstr=unsafe_filter)


# if __name__ == "__main__":
#     app.run(debug=True)
