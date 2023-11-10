/**
 * @name Extract MaD neutral model rows.
 * @description This extracts the Models as data neutral model rows.
 * @id cs/utils/modelconverter/generate-data-extensions-neutral
 */

import csharp
import InterpretModel

from
  string namespace0, string namespace, string type0, string type, string name0, string name,
  string signature0, string signature, string kind, string provenance
where
  neutralModel(namespace0, type0, name0, signature0, kind, provenance) and
  interpretCallable(namespace0, namespace, type0, type, name0, name, signature0, signature)
select namespace, type, name, signature, kind, provenance order by
    namespace, type, name, signature, kind
