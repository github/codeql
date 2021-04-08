import javascript

query predicate punycode(DataFlow::Node n) { n = punycode::punycodeMember(_) }

query predicate querydashstring(DataFlow::Node n) { n = querydashstring::querydashstringMember(_) }

query predicate querystring(DataFlow::Node n) { n = querystring::querystringMember(_) }

query predicate querystringify(DataFlow::Node n) { n = querystringify::querystringifyMember(_) }

query predicate uridashjs(DataFlow::Node n) { n = uridashjs::uridashjsMember(_) }

query predicate urijs(DataFlow::Node n) { n = urijs::urijs() }

query predicate uriLibraryStep(DataFlow::Node pred, DataFlow::Node succ) {
  TaintTracking::uriStep(pred, succ)
}

query predicate url(DataFlow::Node n) { n = url::urlMember(_) }

query predicate urlParse(DataFlow::Node n) { n = urlParse::urlParse() }
