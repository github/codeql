/**
 * @name Extract MaD source model rows.
 * @description This extracts the Models as data source model rows.
 * @id cs/utils/modelconverter/generate-data-extensions-source
 */

import csharp
import InterpretModel

from
  string namespace0, string namespace, string type0, string type, boolean subtypes, string name0,
  string name, string signature0, string signature, string ext, string output, string kind,
  string provenance
where
  sourceModel(namespace0, type0, subtypes, name0, signature0, ext, output, kind, provenance, _) and
  interpretCallable(namespace0, namespace, type0, type, name0, name, signature0, signature)
select namespace, type, subtypes, name, signature, ext, output, kind, provenance order by
    namespace, type, name, signature, output, kind
