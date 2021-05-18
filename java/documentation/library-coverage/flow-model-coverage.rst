Java framework & library support
================================

.. csv-table::
   :header-rows: 1
   :class: fullWidthTable
   :widths: auto

   Framework / library,Package,Remote flow sources,Taint & value steps,Sinks (total),`CWE‑022` :sub:`Path injection`,`CWE‑036` :sub:`Path traversal`,`CWE‑079` :sub:`Cross-site scripting`,`CWE‑089` :sub:`SQL injection`,`CWE‑090` :sub:`LDAP injection`,`CWE‑094` :sub:`Code injection`,`CWE‑319` :sub:`Cleartext transmission`
   Android,``android.*``,18,,3,,,3,,,,
   Apache,``org.apache.*``,5,648,4,,,3,,1,,
   `Apache Commons IO <https://commons.apache.org/proper/commons-io/>`_,``org.apache.commons.io``,,22,,,,,,,,
   Google,``com.google.common.*``,,96,6,,6,,,,,
   Java Standard Library,``java.*``,3,41,15,13,,,,,,2
   Java extensions,``javax.*``,22,8,9,,,1,,1,1,
   `Spring <https://spring.io/>`_,``org.springframework.*``,23,,14,,,,,14,,
   Others,"``com.esotericsoftware.kryo.io``, ``com.unboundid.ldap.sdk``, ``org.xml.sax``, ``org.xmlpull.v1``, ``play.mvc``",7,2,17,,,,,17,,
   Totals,,78,817,68,13,6,7,,33,1,2

