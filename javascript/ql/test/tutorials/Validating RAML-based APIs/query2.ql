import javascript

string httpVerb() {
  result = "get" or
  result = "put" or
  result = "post" or
  result = "delete"
}

/** A RAML specification. */
class RAMLSpec extends YAMLDocument, YAMLMapping {
  RAMLSpec() { getLocation().getFile().getExtension() = "raml" }
}

/** A RAML resource specification. */
class RAMLResource extends YAMLMapping {
  RAMLResource() {
    getDocument() instanceof RAMLSpec and
    exists(YAMLMapping m, string name |
      this = m.lookup(name) and
      name.matches("/%")
    )
  }

  /** Get the path of this resource relative to the API root. */
  string getPath() {
    exists(RAMLSpec spec | this = spec.lookup(result))
    or
    exists(RAMLResource that, string p |
      this = that.lookup(p) and
      result = that.getPath() + p
    )
  }

  /** Get the method for this resource with the given verb. */
  RAMLMethod getMethod(string verb) {
    verb = httpVerb() and
    result = lookup(verb)
  }
}

/** A RAML method specification. */
class RAMLMethod extends YAMLValue {
  RAMLMethod() {
    getDocument() instanceof RAMLSpec and
    exists(YAMLMapping obj | this = obj.lookup(httpVerb()))
  }

  /** Get the response specification for the given status code. */
  YAMLValue getResponse(int code) {
    exists(YAMLMapping obj, string s |
      obj = this.(YAMLMapping).lookup("responses") and
      result = obj.lookup(s) and
      code = s.toInt()
    )
  }
}

from RAMLResource rr
select rr, rr.getPath()
