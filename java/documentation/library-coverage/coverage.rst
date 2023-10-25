Java framework & library support
================================

.. csv-table::
   :header-rows: 1
   :class: fullWidthTable
   :widths: auto

   Framework / library,Package,Flow sources,Taint & value steps,Sinks (total),`CWE‑022` :sub:`Path injection`,`CWE‑079` :sub:`Cross-site scripting`,`CWE‑089` :sub:`SQL injection`,`CWE‑090` :sub:`LDAP injection`,`CWE‑094` :sub:`Code injection`,`CWE‑918` :sub:`Request Forgery`
   Android,``android.*``,52,481,138,,3,67,,,
   Android extensions,``androidx.*``,5,183,19,,,,,,
   `Apache Commons Collections <https://commons.apache.org/proper/commons-collections/>`_,"``org.apache.commons.collections``, ``org.apache.commons.collections4``",,1600,,,,,,,
   `Apache Commons IO <https://commons.apache.org/proper/commons-io/>`_,``org.apache.commons.io``,,560,111,94,,,,,15
   `Apache Commons Lang <https://commons.apache.org/proper/commons-lang/>`_,``org.apache.commons.lang3``,,425,6,,,,,,
   `Apache Commons Text <https://commons.apache.org/proper/commons-text/>`_,``org.apache.commons.text``,,272,,,,,,,
   `Apache HttpComponents <https://hc.apache.org/>`_,"``org.apache.hc.core5.*``, ``org.apache.http``",5,183,122,,3,,,,119
   `Apache Log4j 2 <https://logging.apache.org/log4j/2.0/>`_,``org.apache.logging.log4j``,,8,359,,,,,,
   `Google Guava <https://guava.dev/>`_,``com.google.common.*``,,730,41,7,,,,,
   JBoss Logging,``org.jboss.logging``,,,324,,,,,,
   `JSON-java <https://github.com/stleary/JSON-java>`_,``org.json``,,236,,,,,,,
   Java Standard Library,``java.*``,10,692,201,76,,9,,,18
   Java extensions,"``javax.*``, ``jakarta.*``",67,686,42,4,4,,1,1,4
   Kotlin Standard Library,``kotlin*``,,1849,16,14,,,,,2
   `Spring <https://spring.io/>`_,``org.springframework.*``,29,489,115,4,,28,14,,35
   Others,"``actions.osgi``, ``antlr``, ``cn.hutool.core.codec``, ``com.alibaba.druid.sql``, ``com.alibaba.fastjson2``, ``com.esotericsoftware.kryo.io``, ``com.esotericsoftware.kryo5.io``, ``com.fasterxml.jackson.core``, ``com.fasterxml.jackson.databind``, ``com.google.gson``, ``com.hubspot.jinjava``, ``com.jcraft.jsch``, ``com.mitchellbosecke.pebble``, ``com.opensymphony.xwork2``, ``com.rabbitmq.client``, ``com.thoughtworks.xstream``, ``com.unboundid.ldap.sdk``, ``com.zaxxer.hikari``, ``flexjson``, ``freemarker.cache``, ``freemarker.template``, ``groovy.lang``, ``groovy.text``, ``groovy.util``, ``hudson``, ``io.jsonwebtoken``, ``io.netty.bootstrap``, ``io.netty.buffer``, ``io.netty.channel``, ``io.netty.handler.codec``, ``io.netty.handler.ssl``, ``io.netty.handler.stream``, ``io.netty.resolver``, ``io.netty.util``, ``javafx.scene.web``, ``jenkins``, ``jodd.json``, ``net.sf.json``, ``net.sf.saxon.s9api``, ``ognl``, ``okhttp3``, ``org.acegisecurity``, ``org.antlr.runtime``, ``org.apache.commons.codec``, ``org.apache.commons.compress.archivers.tar``, ``org.apache.commons.exec``, ``org.apache.commons.httpclient.util``, ``org.apache.commons.jelly``, ``org.apache.commons.jexl2``, ``org.apache.commons.jexl3``, ``org.apache.commons.lang``, ``org.apache.commons.logging``, ``org.apache.commons.net``, ``org.apache.commons.ognl``, ``org.apache.cxf.catalog``, ``org.apache.cxf.common.classloader``, ``org.apache.cxf.common.jaxb``, ``org.apache.cxf.common.logging``, ``org.apache.cxf.configuration.jsse``, ``org.apache.cxf.helpers``, ``org.apache.cxf.resource``, ``org.apache.cxf.staxutils``, ``org.apache.cxf.tools.corba.utils``, ``org.apache.cxf.tools.util``, ``org.apache.cxf.transform``, ``org.apache.directory.ldap.client.api``, ``org.apache.hadoop.fs``, ``org.apache.hadoop.hive.metastore``, ``org.apache.hc.client5.http.async.methods``, ``org.apache.hc.client5.http.classic.methods``, ``org.apache.hc.client5.http.fluent``, ``org.apache.hive.hcatalog.templeton``, ``org.apache.ibatis.jdbc``, ``org.apache.log4j``, ``org.apache.shiro.codec``, ``org.apache.shiro.jndi``, ``org.apache.struts.beanvalidation.validation.interceptor``, ``org.apache.struts2``, ``org.apache.tools.ant``, ``org.apache.tools.zip``, ``org.apache.velocity.app``, ``org.apache.velocity.runtime``, ``org.codehaus.cargo.container.installer``, ``org.codehaus.groovy.control``, ``org.dom4j``, ``org.eclipse.jetty.client``, ``org.fusesource.leveldbjni``, ``org.geogebra.web.full.main``, ``org.gradle.api.file``, ``org.hibernate``, ``org.influxdb``, ``org.jdbi.v3.core``, ``org.jenkins.ui.icon``, ``org.jenkins.ui.symbol``, ``org.jooq``, ``org.kohsuke.stapler``, ``org.mvel2``, ``org.openjdk.jmh.runner.options``, ``org.owasp.esapi``, ``org.scijava.log``, ``org.slf4j``, ``org.thymeleaf``, ``org.xml.sax``, ``org.xmlpull.v1``, ``org.yaml.snakeyaml``, ``play.libs.ws``, ``play.mvc``, ``ratpack.core.form``, ``ratpack.core.handling``, ``ratpack.core.http``, ``ratpack.exec``, ``ratpack.form``, ``ratpack.func``, ``ratpack.handling``, ``ratpack.http``, ``ratpack.util``, ``retrofit2``",131,10503,706,116,6,18,18,,208
   Totals,,299,18897,2200,315,16,122,33,1,401

