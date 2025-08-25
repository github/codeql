/**
 * @name Extract MaD sink model rows.
 * @description This extracts the Models as data sink model rows.
 * @id java/utils/modelconverter/generate-data-extensions-sink
 */

import java
import semmle.code.java.dataflow.ExternalFlow

from
  string package, string type, boolean subtypes, string name, string signature, string ext,
  string input, string kind, string provenance
where
  sinkModel(package, type, subtypes, name, signature, ext, input, kind, provenance, _) and
  not provenance.matches("%generated")
select package, type, subtypes, name, signature, ext, input, kind, provenance order by
    package, type, name, signature, input, kind
