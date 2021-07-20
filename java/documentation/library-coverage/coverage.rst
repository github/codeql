Java framework & library support
================================

.. csv-table::
   :header-rows: 1
   :class: fullWidthTable
   :widths: auto

   Framework / library,Package,Flow sources,Taint & value steps,Sinks (total),`CWE‑022` :sub:`Path injection`,`CWE‑036` :sub:`Path traversal`,`CWE‑079` :sub:`Cross-site scripting`,`CWE‑089` :sub:`SQL injection`,`CWE‑090` :sub:`LDAP injection`,`CWE‑094` :sub:`Code injection`,`CWE‑319` :sub:`Cleartext transmission`
   Android,``android.*``,18,34,70,,,3,67,,,
   `Apache Commons Collections <https://commons.apache.org/proper/commons-collections/>`_,"``org.apache.commons.collections``, ``org.apache.commons.collections4``",,198,,,,,,,,
   `Apache Commons IO <https://commons.apache.org/proper/commons-io/>`_,``org.apache.commons.io``,,22,,,,,,,,
   `Apache Commons Lang <https://commons.apache.org/proper/commons-lang/>`_,``org.apache.commons.lang3``,,423,,,,,,,,
   `Apache Commons Text <https://commons.apache.org/proper/commons-text/>`_,``org.apache.commons.text``,,272,,,,,,,,
   `Apache HttpComponents <https://hc.apache.org/>`_,"``org.apache.hc.core5.*``, ``org.apache.http``",5,136,28,,,3,,,,25
   `Google Guava <https://guava.dev/>`_,``com.google.common.*``,,158,6,,6,,,,,
   Java Standard Library,``java.*``,3,327,30,13,,,7,,,10
   Java extensions,"``javax.*``, ``jakarta.*``",22,540,18,,,,,1,1,2
   `Spring <https://spring.io/>`_,``org.springframework.*``,29,306,62,,,,19,14,,29
   Others,"``com.esotericsoftware.kryo.io``, ``com.esotericsoftware.kryo5.io``, ``com.fasterxml.jackson.databind``, ``com.unboundid.ldap.sdk``, ``org.apache.commons.codec``, ``org.apache.commons.jexl2``, ``org.apache.commons.jexl3``, ``org.apache.directory.ldap.client.api``, ``org.apache.ibatis.jdbc``, ``org.dom4j``, ``org.hibernate``, ``org.jooq``, ``org.xml.sax``, ``org.xmlpull.v1``, ``play.mvc``",7,12,82,,,,14,18,,
   Totals,,84,2428,296,13,6,6,107,33,1,66

