import javascript

/** A RAML specification. */
class RamlSpec extends YamlDocument, YamlMapping {
  RamlSpec() { this.getLocation().getFile().getExtension() = "raml" }
}

from RamlSpec s
select s
