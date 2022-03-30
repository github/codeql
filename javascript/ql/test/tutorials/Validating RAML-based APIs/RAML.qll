/* Model of RAML specifications. */
import javascript
import HTTP

/** A RAML specification. */
class RamlSpec extends YAMLDocument, YAMLMapping {
  RamlSpec() { getLocation().getFile().getExtension() = "raml" }
}

/** DEPRECATED: Alias for RamlSpec */
deprecated class RAMLSpec = RamlSpec;

/** A RAML resource specification. */
class RamlResource extends YAMLMapping {
  RamlResource() {
    getDocument() instanceof RamlSpec and
    exists(YAMLMapping m, string name |
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
    result = lookup(verb)
  }
}

/** DEPRECATED: Alias for RamlResource */
deprecated class RAMLResource = RamlResource;

/** A RAML method specification. */
class RamlMethod extends YAMLValue {
  RamlMethod() {
    getDocument() instanceof RamlSpec and
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

/** DEPRECATED: Alias for RamlMethod */
deprecated class RAMLMethod = RamlMethod;
