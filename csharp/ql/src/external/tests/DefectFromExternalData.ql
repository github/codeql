/**
 * @name Defect from external data
 * @description Insert description here...
 * @kind problem
 * @problem.severity warning
 * @deprecated
 */

import csharp
import external.ExternalArtifact

// custom://[FileUtil][2011-01-02][false][1.1][6][Message 2]
from ExternalData d, File u
where
  d.getQueryPath() = "external-data.ql" and
  u.getStem() = d.getField(0)
select u,
  d.getField(5) + ", " + d.getFieldAsDate(1) + ", " + d.getField(2) + ", " + d.getFieldAsFloat(3) +
    ", " + d.getFieldAsInt(4) + ": " + d.getNumFields()
