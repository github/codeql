import javascript

/** A RAML specification. */
class RamlSpec extends YAMLDocument, YAMLMapping {
  RamlSpec() { getLocation().getFile().getExtension() = "raml" }
}

from RamlSpec s
select s
