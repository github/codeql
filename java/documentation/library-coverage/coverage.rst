Java framework & library support
================================

.. csv-table::
   :header-rows: 1
   :class: fullWidthTable
   :widths: auto

   Framework / library,Package,Flow sources,Taint & value steps,Sinks (total),`CWE‑022` :sub:`Path injection`,`CWE‑036` :sub:`Path traversal`,`CWE‑079` :sub:`Cross-site scripting`,`CWE‑089` :sub:`SQL injection`,`CWE‑090` :sub:`LDAP injection`,`CWE‑094` :sub:`Code injection`,`CWE‑319` :sub:`Cleartext transmission`
   Android,``android.*``,52,479,116,,,3,67,,,
   `Apache Commons Collections <https://commons.apache.org/proper/commons-collections/>`_,"``org.apache.commons.collections``, ``org.apache.commons.collections4``",,1600,,,,,,,,
   `Apache Commons IO <https://commons.apache.org/proper/commons-io/>`_,``org.apache.commons.io``,,556,106,91,,,,,,15
   `Apache Commons Lang <https://commons.apache.org/proper/commons-lang/>`_,``org.apache.commons.lang3``,,424,,,,,,,,
   `Apache Commons Text <https://commons.apache.org/proper/commons-text/>`_,``org.apache.commons.text``,,272,,,,,,,,
   `Apache HttpComponents <https://hc.apache.org/>`_,"``org.apache.hc.core5.*``, ``org.apache.http``",5,136,28,,,3,,,,25
   `Google Guava <https://guava.dev/>`_,``com.google.common.*``,,728,39,,6,,,,,
   `JSON-java <https://github.com/stleary/JSON-java>`_,``org.json``,,236,,,,,,,,
   Java Standard Library,``java.*``,3,585,130,28,,,7,,,10
   Java extensions,"``javax.*``, ``jakarta.*``",63,609,32,,,4,,1,1,2
   `Spring <https://spring.io/>`_,``org.springframework.*``,29,477,101,,,,19,14,,29
   Others,"``androidx.slice``, ``cn.hutool.core.codec``, ``com.esotericsoftware.kryo.io``, ``com.esotericsoftware.kryo5.io``, ``com.fasterxml.jackson.core``, ``com.fasterxml.jackson.databind``, ``com.opensymphony.xwork2.ognl``, ``com.rabbitmq.client``, ``com.unboundid.ldap.sdk``, ``com.zaxxer.hikari``, ``flexjson``, ``groovy.lang``, ``groovy.util``, ``jodd.json``, ``kotlin``, ``net.sf.saxon.s9api``, ``ognl``, ``okhttp3``, ``org.apache.commons.codec``, ``org.apache.commons.jexl2``, ``org.apache.commons.jexl3``, ``org.apache.commons.logging``, ``org.apache.commons.ognl``, ``org.apache.directory.ldap.client.api``, ``org.apache.ibatis.jdbc``, ``org.apache.log4j``, ``org.apache.logging.log4j``, ``org.apache.shiro.codec``, ``org.apache.shiro.jndi``, ``org.codehaus.groovy.control``, ``org.dom4j``, ``org.hibernate``, ``org.jboss.logging``, ``org.jdbi.v3.core``, ``org.jooq``, ``org.mvel2``, ``org.scijava.log``, ``org.slf4j``, ``org.xml.sax``, ``org.xmlpull.v1``, ``play.mvc``, ``ratpack.core.form``, ``ratpack.core.handling``, ``ratpack.core.http``, ``ratpack.exec``, ``ratpack.form``, ``ratpack.func``, ``ratpack.handling``, ``ratpack.http``, ``ratpack.util``, ``retrofit2``",65,2229,944,10,,,14,18,,5
   Totals,,217,8331,1496,129,6,10,107,33,1,86

