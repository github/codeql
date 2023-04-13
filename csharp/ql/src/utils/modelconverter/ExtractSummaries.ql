/**
 * @name Extract MaD summary model rows.
 * @description This extracts the Models as data summary model rows.
 * @id cs/utils/modelconverter/generate-data-extensions-summary
 */

import csharp
import semmle.code.csharp.dataflow.ExternalFlow

from
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string input, string output, string kind, string provenance
where
  summaryModel(namespace, type, subtypes, name, signature, ext, input, output, kind, provenance) and
  not provenance.matches("%generated")
select namespace, type, subtypes, name, signature, ext, input, output, kind, provenance order by
    namespace, type, name, signature, input, output, kind
