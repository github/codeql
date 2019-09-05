/**
 * @name Defect from external data
 * @description Insert description here...
 * @kind problem
 * @problem.severity warning
 * @tags external-data
 */

import cpp
import external.ExternalArtifact

from ExternalData d, File u
where
  d.getQueryPath() = "external-data.ql" and
  u.getShortName() = d.getField(0)
select u,
  d.getField(5) + ", " + d.getFieldAsDate(1) + ", " + d.getField(2) + ", " + d.getFieldAsFloat(3) +
    ", " + d.getFieldAsInt(4) + ": " + d.getNumFields()
