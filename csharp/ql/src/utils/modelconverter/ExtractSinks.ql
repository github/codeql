/**
 * @name Extract MaD sink model rows.
 * @description This extracts the Models as data sink model rows.
 * @id cs/utils/modelconverter/generate-data-extensions-sink
 */

import csharp
import semmle.code.csharp.dataflow.ExternalFlow

from
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string input, string kind, string provenance
where
  sinkModel(namespace, type, subtypes, name, signature, ext, input, kind, provenance) and
  not provenance.matches("%generated")
select namespace, type, subtypes, name, signature, ext, input, kind, provenance order by
    namespace, type, name, signature, input, kind
