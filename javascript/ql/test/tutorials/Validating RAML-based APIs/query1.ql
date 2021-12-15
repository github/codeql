import javascript

/** A RAML specification. */
class RAMLSpec extends YAMLDocument, YAMLMapping {
  RAMLSpec() { getLocation().getFile().getExtension() = "raml" }
}

from RAMLSpec s
select s
