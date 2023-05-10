/**
 * @name Extract MaD neutral model rows.
 * @description This extracts the Models as data neutral model rows.
 * @id cs/utils/modelconverter/generate-data-extensions-neutral
 */

import csharp
import semmle.code.csharp.dataflow.ExternalFlow

from string package, string type, string name, string signature, string kind, string provenance
where
  neutralModel(package, type, name, signature, kind, provenance) and
  not provenance.matches("%generated")
select package, type, name, signature, kind, provenance order by
    package, type, name, signature, kind
