goog.module('closureUri');

let Uri = goog.require('goog.Uri');

let uri = new Uri(x);
Uri.parse(x);
Uri.resolve(x, y);
Uri.create(scheme, cred, domain, port, path, query, frag);

uri.setScheme(x);
uri.setUserInfo(x);
uri.setDomain(x);
uri.setPort(x);
uri.setPath(x);
uri.setQuery(x);
uri.setFragment(x);

uri.setQuery(x).setPath(y).setScheme(z);

let utils = goog.require('goog.uri.utils');

utils.appendParam(uri, z);
utils.getPath(uri);

let stringUtil = goog.require('goog.string');

stringUtil.urlEncode(x);
stringUtil.urlDecode(x);
