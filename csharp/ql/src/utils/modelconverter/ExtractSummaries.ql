/**
 * @name Extract MaD summary model rows.
 * @description This extracts the Models as data summary model rows.
 * @id cs/utils/modelconverter/generate-data-extensions-summary
 */

import csharp
import InterpretModel

from
  string namespace0, string namespace, string type0, string type, boolean subtypes, string name0,
  string name, string signature0, string signature, string ext, string input, string output,
  string kind, string provenance
where
  summaryModel(namespace0, type0, subtypes, name0, signature0, ext, input, output, kind, provenance,
    _) and
  interpretCallable(namespace0, namespace, type0, type, name0, name, signature0, signature)
select namespace, type, subtypes, name, signature, ext, input, output, kind, provenance order by
    namespace, type, name, signature, input, output, kind
