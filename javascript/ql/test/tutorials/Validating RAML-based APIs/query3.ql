import javascript

string httpVerb() { result = ["get", "put", "post", "delete"] }

/** A RAML specification. */
class RamlSpec extends YamlDocument, YamlMapping {
  RamlSpec() { this.getLocation().getFile().getExtension() = "raml" }
}

/** A RAML resource specification. */
class RamlResource extends YamlMapping {
  RamlResource() {
    this.getDocument() instanceof RamlSpec and
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

class RamlMethod extends YamlValue {
  RamlMethod() {
    this.getDocument() instanceof RamlSpec and
    exists(YamlMapping obj | this = obj.lookup(httpVerb()))
  }
}

select 1
