/**
 * @name Extract MaD source model rows.
 * @description This extracts the Models as data source model rows.
 * @id java/utils/modelconverter/generate-data-extensions-source
 */

import java
import semmle.code.java.dataflow.ExternalFlow

from
  string package, string type, boolean subtypes, string name, string signature, string ext,
  string output, string kind, string provenance
where
  sourceModel(package, type, subtypes, name, signature, ext, output, kind, provenance, _) and
  not provenance.matches("%generated")
select package, type, subtypes, name, signature, ext, output, kind, provenance order by
    package, type, name, signature, output, kind
