Java framework & library support
================================

.. csv-table::
   :header-rows: 1
   :class: fullWidthTable
   :widths: auto

   Framework / library,Package,Flow sources,Taint & value steps,Sinks (total),`CWE‑022` :sub:`Path injection`,`CWE‑036` :sub:`Path traversal`,`CWE‑079` :sub:`Cross-site scripting`,`CWE‑089` :sub:`SQL injection`,`CWE‑090` :sub:`LDAP injection`,`CWE‑094` :sub:`Code injection`,`CWE‑319` :sub:`Cleartext transmission`
   Android,``android.*``,52,481,138,,,3,67,,,
   Android extensions,``androidx.*``,5,183,19,,,,,,,
   `Apache Commons Collections <https://commons.apache.org/proper/commons-collections/>`_,"``org.apache.commons.collections``, ``org.apache.commons.collections4``",,1600,,,,,,,,
   `Apache Commons IO <https://commons.apache.org/proper/commons-io/>`_,``org.apache.commons.io``,,560,107,91,,,,,,15
   `Apache Commons Lang <https://commons.apache.org/proper/commons-lang/>`_,``org.apache.commons.lang3``,,424,6,,,,,,,
   `Apache Commons Text <https://commons.apache.org/proper/commons-text/>`_,``org.apache.commons.text``,,272,,,,,,,,
   `Apache HttpComponents <https://hc.apache.org/>`_,"``org.apache.hc.core5.*``, ``org.apache.http``",5,143,28,,,3,,,,25
   `Apache Log4j 2 <https://logging.apache.org/log4j/2.0/>`_,``org.apache.logging.log4j``,,8,359,,,,,,,
   `Google Guava <https://guava.dev/>`_,``com.google.common.*``,,730,39,,6,,,,,
   JBoss Logging,``org.jboss.logging``,,,324,,,,,,,
   `JSON-java <https://github.com/stleary/JSON-java>`_,``org.json``,,236,,,,,,,,
   Java Standard Library,``java.*``,3,667,152,36,,,9,,,12
   Java extensions,"``javax.*``, ``jakarta.*``",63,611,34,1,,4,,1,1,2
   Kotlin Standard Library,``kotlin*``,,1835,12,10,,,,,,2
   `Spring <https://spring.io/>`_,``org.springframework.*``,29,480,101,,,,19,14,,29
   Others,"``cn.hutool.core.codec``, ``com.esotericsoftware.kryo.io``, ``com.esotericsoftware.kryo5.io``, ``com.fasterxml.jackson.core``, ``com.fasterxml.jackson.databind``, ``com.hubspot.jinjava``, ``com.mitchellbosecke.pebble``, ``com.opensymphony.xwork2.ognl``, ``com.rabbitmq.client``, ``com.thoughtworks.xstream``, ``com.unboundid.ldap.sdk``, ``com.zaxxer.hikari``, ``flexjson``, ``freemarker.cache``, ``freemarker.template``, ``groovy.lang``, ``groovy.util``, ``hudson``, ``io.netty.bootstrap``, ``io.netty.buffer``, ``io.netty.channel``, ``io.netty.handler.codec``, ``io.netty.handler.ssl``, ``io.netty.handler.stream``, ``io.netty.resolver``, ``io.netty.util``, ``javafx.scene.web``, ``jodd.json``, ``net.sf.saxon.s9api``, ``ognl``, ``okhttp3``, ``org.apache.commons.codec``, ``org.apache.commons.compress.archivers.tar``, ``org.apache.commons.jelly``, ``org.apache.commons.jexl2``, ``org.apache.commons.jexl3``, ``org.apache.commons.logging``, ``org.apache.commons.ognl``, ``org.apache.directory.ldap.client.api``, ``org.apache.hadoop.hive.metastore``, ``org.apache.hive.hcatalog.templeton``, ``org.apache.ibatis.jdbc``, ``org.apache.log4j``, ``org.apache.shiro.codec``, ``org.apache.shiro.jndi``, ``org.apache.tools.ant``, ``org.apache.tools.zip``, ``org.apache.velocity.app``, ``org.apache.velocity.runtime``, ``org.codehaus.cargo.container.installer``, ``org.codehaus.groovy.control``, ``org.dom4j``, ``org.geogebra.web.full.main``, ``org.hibernate``, ``org.jdbi.v3.core``, ``org.jooq``, ``org.kohsuke.stapler``, ``org.mvel2``, ``org.openjdk.jmh.runner.options``, ``org.scijava.log``, ``org.slf4j``, ``org.thymeleaf``, ``org.xml.sax``, ``org.xmlpull.v1``, ``play.mvc``, ``ratpack.core.form``, ``ratpack.core.handling``, ``ratpack.core.http``, ``ratpack.exec``, ``ratpack.form``, ``ratpack.func``, ``ratpack.handling``, ``ratpack.http``, ``ratpack.util``, ``retrofit2``",75,813,364,26,,,18,18,,33
   Totals,,232,9043,1683,164,6,10,113,33,1,118

