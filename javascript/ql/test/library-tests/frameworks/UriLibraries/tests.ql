import javascript

query predicate punycode(DataFlow::Node n) { n = Punycode::punycodeMember(_) }

query predicate querydashstring(DataFlow::Node n) { n = Querydashstring::querydashstringMember(_) }

query predicate querystring(DataFlow::Node n) { n = Querystring::querystringMember(_) }

query predicate querystringify(DataFlow::Node n) { n = Querystringify::querystringifyMember(_) }

query predicate uridashjs(DataFlow::Node n) { n = Uridashjs::uridashjsMember(_) }

query predicate urijs(DataFlow::Node n) { n = Urijs::urijs() }

query predicate uriLibraryStep(DataFlow::Node pred, DataFlow::Node succ) {
  TaintTracking::uriStep(pred, succ)
}

query predicate url(DataFlow::Node n) { n = Url::urlMember(_) }

query predicate urlParse(DataFlow::Node n) { n = UrlParse::urlParse() }
