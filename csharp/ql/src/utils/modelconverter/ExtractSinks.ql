/**
 * @name Extract MaD sink model rows.
 * @description This extracts the Models as data sink model rows.
 * @id cs/utils/modelconverter/generate-data-extensions-sink
 */

import csharp
import InterpretModel

from
  string namespace0, string namespace, string type0, string type, boolean subtypes, string name0,
  string name, string signature0, string signature, string ext, string input, string kind,
  string provenance
where
  sinkModel(namespace0, type0, subtypes, name0, signature0, ext, input, kind, provenance, _) and
  interpretCallable(namespace0, namespace, type0, type, name0, name, signature0, signature)
select namespace, type, subtypes, name, signature, ext, input, kind, provenance order by
    namespace, type, name, signature, input, kind
