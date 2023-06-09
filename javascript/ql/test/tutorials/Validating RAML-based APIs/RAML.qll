/** Model of RAML specifications. */

import javascript
import HTTP

/** A RAML specification. */
class RamlSpec extends YamlDocument, YamlMapping {
  RamlSpec() { getLocation().getFile().getExtension() = "raml" }
}

/** A RAML resource specification. */
class RamlResource extends YamlMapping {
  RamlResource() {
    getDocument() instanceof RamlSpec and
    exists(YamlMapping m, string name |
      this = m.lookup(name) and
      name.matches("/%")
    )
  }

  /** Get the path of this resource relative to the API root. */
  string getPath() {
    exists(RamlSpec spec | this = spec.lookup(result))
    or
    exists(RamlResource that, string p |
      this = that.lookup(p) and
      result = that.getPath() + p
    )
  }

  /** Get the method for this resource with the given verb. */
  RamlMethod getMethod(string verb) {
    verb = httpVerb() and
    result = this.lookup(verb)
  }
}

/** A RAML method specification. */
class RamlMethod extends YamlValue {
  RamlMethod() {
    getDocument() instanceof RamlSpec and
    exists(YamlMapping obj | this = obj.lookup(httpVerb()))
  }

  /** Get the response specification for the given status code. */
  YamlValue getResponse(int code) {
    exists(YamlMapping obj, string s |
      obj = this.(YamlMapping).lookup("responses") and
      result = obj.lookup(s) and
      code = s.toInt()
    )
  }
}
