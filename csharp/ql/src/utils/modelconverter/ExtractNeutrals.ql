/**
 * @name Extract MaD neutral model rows.
 * @description This extracts the Models as data neutral model rows.
 * @id cs/utils/modelconverter/generate-data-extensions-neutral
 */

import csharp
import semmle.code.csharp.dataflow.ExternalFlow

from string package, string type, string name, string signature, string provenance
where
  neutralModel(package, type, name, signature, provenance) and
  provenance != "generated"
select package, type, name, signature, provenance order by package, type, name, signature
