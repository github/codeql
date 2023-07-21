/**
 * @name Extract MaD source model rows.
 * @description This extracts the Models as data source model rows.
 * @id cs/utils/modelconverter/generate-data-extensions-source
 */

import csharp
import semmle.code.csharp.dataflow.ExternalFlow

from
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string output, string kind, string provenance
where
  sourceModel(namespace, type, subtypes, name, signature, ext, output, kind, provenance) and
  not provenance.matches("%generated")
select namespace, type, subtypes, name, signature, ext, output, kind, provenance order by
    namespace, type, name, signature, output, kind
