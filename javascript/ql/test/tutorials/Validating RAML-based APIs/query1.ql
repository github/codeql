import javascript

/** A RAML specification. */
class RamlSpec extends YamlDocument, YamlMapping {
  RamlSpec() { getLocation().getFile().getExtension() = "raml" }
}

from RamlSpec s
select s
