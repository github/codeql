Java framework & library support
================================

.. csv-table::
   :header-rows: 1
   :class: fullWidthTable
   :widths: auto

   Framework / library,Package,Remote flow sources,Taint & value steps,Sinks (total),`CWE‑022` :sub:`Path injection`,`CWE‑036` :sub:`Path traversal`,`CWE‑079` :sub:`Cross-site scripting`,`CWE‑089` :sub:`SQL injection`,`CWE‑090` :sub:`LDAP injection`,`CWE‑094` :sub:`Code injection`,`CWE‑319` :sub:`Cleartext transmission`
   Android,``android.*``,18,,3,,,3,,,,
   Apache,``org.apache.*``,5,682,4,,,3,,1,,
   `Apache Commons IO <https://commons.apache.org/proper/commons-io/>`_,``org.apache.commons.io``,,22,,,,,,,,
   Google,``com.google.common.*``,,107,6,,6,,,,,
   Java Standard Library,``java.*``,3,313,15,13,,,,,,2
   Java extensions,``javax.*``,22,8,12,,,1,,1,1,
   `Spring <https://spring.io/>`_,``org.springframework.*``,29,,14,,,,,14,,
   Others,"``com.esotericsoftware.kryo.io``, ``com.esotericsoftware.kryo5.io``, ``com.fasterxml.jackson.databind``, ``com.unboundid.ldap.sdk``, ``org.dom4j``, ``org.xml.sax``, ``org.xmlpull.v1``, ``play.mvc``",7,6,37,,,,,17,,
   Totals,,84,1138,91,13,6,7,,33,1,2

