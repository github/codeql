/**
 * @name Extract MaD negative summary model rows.
 * @description This extracts the Models as data negative summary model rows.
 * @id java/utils/modelconverter/generate-data-extensions-negative-summary
 */

import java
import semmle.code.java.dataflow.ExternalFlow

from string package, string type, string name, string signature, string provenance
where
  negativeSummaryModel(package, type, name, signature, provenance) and
  provenance != "generated"
select package, type, name, signature, provenance order by package, type, name, signature
