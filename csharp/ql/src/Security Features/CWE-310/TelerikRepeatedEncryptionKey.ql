/**
 * @name Non unique encryption keys in Telerik Upload in ASP.NET
 * @description Setting a weak encryption key for ASP.NET Telerik Upload may allow attacks against
 *              the application.
 * @kind problem
 */

import csharp

from XMLAttribute a, XMLAttribute b
where
  a.getName() = "key" and
  a.getValue() = "Telerik.AsyncUpload.ConfigurationEncryptionKey" and
  b.getName() = "key" and
  b.getValue() = "Telerik.Upload.ConfigurationHashKey" and
  a.getElement().getAttributeValue("value") = b.getElement().getAttributeValue("value")
select a,
  "Non unique (duplicated) Telerik Upload encryption key (" +
    a.getElement().getAttributeValue("value").toString() + ")."
