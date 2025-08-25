/**
 * @name Extract MaD summary model rows.
 * @description This extracts the Models as data summary model rows.
 * @id java/utils/modelconverter/generate-data-extensions-summary
 */

import java
import semmle.code.java.dataflow.ExternalFlow

from
  string package, string type, boolean subtypes, string name, string signature, string ext,
  string input, string output, string kind, string provenance
where
  summaryModel(package, type, subtypes, name, signature, ext, input, output, kind, provenance, _) and
  not provenance.matches("%generated")
select package, type, subtypes, name, signature, ext, input, output, kind, provenance order by
    package, type, name, signature, input, output, kind
