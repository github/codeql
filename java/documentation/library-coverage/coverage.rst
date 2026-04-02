Java framework & library support
================================

.. csv-table::
   :header-rows: 1
   :class: fullWidthTable
   :widths: auto

   Framework / library,Package,Flow sources,Taint & value steps,Sinks (total),`CWE‑022` :sub:`Path injection`,`CWE‑079` :sub:`Cross-site scripting`,`CWE‑089` :sub:`SQL injection`,`CWE‑090` :sub:`LDAP injection`,`CWE‑094` :sub:`Code injection`,`CWE‑918` :sub:`Request Forgery`
   Android,``android.*``,52,481,181,1,3,67,,,
   Android extensions,``androidx.*``,5,183,60,,,,,,
   `Apache Commons Collections <https://commons.apache.org/proper/commons-collections/>`_,"``org.apache.commons.collections``, ``org.apache.commons.collections4``",,1606,,,,,,,
   `Apache Commons IO <https://commons.apache.org/proper/commons-io/>`_,``org.apache.commons.io``,,570,124,105,,,,,15
   `Apache Commons Lang <https://commons.apache.org/proper/commons-lang/>`_,``org.apache.commons.lang3``,,425,7,,,,,,
   `Apache Commons Text <https://commons.apache.org/proper/commons-text/>`_,``org.apache.commons.text``,,272,,,,,,,
   `Apache HttpComponents <https://hc.apache.org/>`_,"``org.apache.hc.core5.*``, ``org.apache.http``",5,183,122,,3,,,,119
   `Apache Log4j 2 <https://logging.apache.org/log4j/2.0/>`_,``org.apache.logging.log4j``,,8,359,,,,,,
   `Apache Struts <https://struts.apache.org/>`_,"``org.apache.struts2``, ``org.apache.struts.beanvalidation.validation.interceptor``",,3877,14,,,,,,
   `Apache Velocity <https://velocity.apache.org/>`_,"``org.apache.velocity.app``, ``org.apache.velocity.runtime``",,,8,,,,,,
   `Couchbase <https://couchbase.com/>`_,``com.couchbase.client.*``,,1,25,,,6,,,
   `FreeMarker <https://freemarker.apache.org/>`_,"``freemarker.cache``, ``freemarker.template``",,,8,,,,,,
   `Google Gson <https://github.com/google/gson>`_,``com.google.gson``,,52,,,,,,,
   `Google Guava <https://guava.dev/>`_,``com.google.common.*``,,730,43,9,,,,,
   `Groovy <https://groovy-lang.org/>`_,"``groovy.lang``, ``groovy.text``, ``groovy.util``, ``org.codehaus.groovy.control``",,,33,,,,,,
   `Hibernate <https://hibernate.org/>`_,``org.hibernate``,,,7,,,7,,,
   `JBoss Logging <https://github.com/jboss-logging/jboss-logging>`_,``org.jboss.logging``,,,324,,,,,,
   `JSON-java <https://github.com/stleary/JSON-java>`_,``org.json``,,236,,,,,,,
   `Jackson <https://github.com/FasterXML/jackson>`_,``com.fasterxml.jackson.*``,,9,2,2,,,,,
   Java Standard Library,``java.*``,10,4629,260,99,,9,,,26
   Java extensions,"``javax.*``, ``jakarta.*``",101,4185,90,10,4,2,1,1,4
   `Jetty <https://eclipse.dev/jetty/>`_,``org.eclipse.jetty.client``,,,2,,,,,,2
   Kotlin Standard Library,``kotlin*``,,1849,16,14,,,,,2
   `MongoDB <https://www.mongodb.com/>`_,``com.mongodb``,,,10,,,,,,
   `Netty <https://netty.io/>`_,``io.netty.*``,15,490,23,7,,,,,16
   `OkHttp <https://square.github.io/okhttp/>`_,``okhttp3``,,50,4,,,,,,4
   `RabbitMQ <https://www.rabbitmq.com/>`_,``com.rabbitmq.client``,21,7,,,,,,,
   `Retrofit <https://square.github.io/retrofit/>`_,``retrofit2``,,1,1,,,,,,1
   `SLF4J <https://www.slf4j.org/>`_,``org.slf4j``,,6,55,,,,,,
   `SnakeYAML <https://github.com/snakeyaml/snakeyaml>`_,``org.yaml.snakeyaml``,,1,,,,,,,
   `Spring <https://spring.io/>`_,``org.springframework.*``,46,494,143,26,,28,14,,35
   `Thymeleaf <https://www.thymeleaf.org/>`_,``org.thymeleaf``,,2,2,,,,,,
   `jOOQ <https://www.jooq.org/>`_,``org.jooq``,,,1,,,1,,,
   Others,"``actions.osgi``, ``antlr``, ``ch.ethz.ssh2``, ``cn.hutool.core.codec``, ``com.alibaba.com.caucho.hessian.io``, ``com.alibaba.druid.sql``, ``com.alibaba.fastjson2``, ``com.amazonaws.auth``, ``com.auth0.jwt.algorithms``, ``com.azure.identity``, ``com.caucho.burlap.io``, ``com.caucho.hessian.io``, ``com.cedarsoftware.util.io``, ``com.esotericsoftware.kryo.io``, ``com.esotericsoftware.kryo5.io``, ``com.esotericsoftware.yamlbeans``, ``com.hubspot.jinjava``, ``com.jcraft.jsch``, ``com.microsoft.sqlserver.jdbc``, ``com.mitchellbosecke.pebble``, ``com.opensymphony.xwork2``, ``com.sshtools.j2ssh.authentication``, ``com.sun.crypto.provider``, ``com.sun.jndi.ldap``, ``com.sun.net.httpserver``, ``com.sun.net.ssl``, ``com.sun.rowset``, ``com.sun.security.auth.module``, ``com.sun.security.ntlm``, ``com.sun.security.sasl.digest``, ``com.thoughtworks.xstream``, ``com.trilead.ssh2``, ``com.unboundid.ldap.sdk``, ``com.zaxxer.hikari``, ``flexjson``, ``hudson``, ``io.jsonwebtoken``, ``io.undertow.server.handlers.resource``, ``javafx.scene.web``, ``jenkins``, ``jodd.json``, ``liquibase.database.jvm``, ``liquibase.statement.core``, ``net.lingala.zip4j``, ``net.schmizz.sshj``, ``net.sf.json``, ``net.sf.saxon.s9api``, ``ognl``, ``org.acegisecurity``, ``org.antlr.runtime``, ``org.apache.commons.codec``, ``org.apache.commons.compress.archivers.tar``, ``org.apache.commons.exec``, ``org.apache.commons.fileupload``, ``org.apache.commons.httpclient.util``, ``org.apache.commons.jelly``, ``org.apache.commons.jexl2``, ``org.apache.commons.jexl3``, ``org.apache.commons.lang``, ``org.apache.commons.logging``, ``org.apache.commons.net``, ``org.apache.commons.ognl``, ``org.apache.cxf.catalog``, ``org.apache.cxf.common.classloader``, ``org.apache.cxf.common.jaxb``, ``org.apache.cxf.common.logging``, ``org.apache.cxf.configuration.jsse``, ``org.apache.cxf.helpers``, ``org.apache.cxf.resource``, ``org.apache.cxf.staxutils``, ``org.apache.cxf.tools.corba.utils``, ``org.apache.cxf.tools.util``, ``org.apache.cxf.transform``, ``org.apache.directory.ldap.client.api``, ``org.apache.hadoop.fs``, ``org.apache.hadoop.hive.metastore``, ``org.apache.hadoop.hive.ql.exec``, ``org.apache.hadoop.hive.ql.metadata``, ``org.apache.hc.client5.http.async.methods``, ``org.apache.hc.client5.http.classic.methods``, ``org.apache.hc.client5.http.fluent``, ``org.apache.hive.hcatalog.templeton``, ``org.apache.ibatis.jdbc``, ``org.apache.ibatis.mapping``, ``org.apache.log4j``, ``org.apache.shiro.authc``, ``org.apache.shiro.codec``, ``org.apache.shiro.jndi``, ``org.apache.shiro.mgt``, ``org.apache.sshd.client.session``, ``org.apache.tools.ant``, ``org.apache.tools.zip``, ``org.codehaus.cargo.container.installer``, ``org.dom4j``, ``org.exolab.castor.xml``, ``org.fusesource.leveldbjni``, ``org.geogebra.web.full.main``, ``org.gradle.api.file``, ``org.ho.yaml``, ``org.influxdb``, ``org.jabsorb``, ``org.jboss.vfs``, ``org.jdbi.v3.core``, ``org.jenkins.ui.icon``, ``org.jenkins.ui.symbol``, ``org.keycloak.models.map.storage``, ``org.kohsuke.stapler``, ``org.lastaflute.web``, ``org.mvel2``, ``org.openjdk.jmh.runner.options``, ``org.owasp.esapi``, ``org.pac4j.jwt.config.encryption``, ``org.pac4j.jwt.config.signature``, ``org.scijava.log``, ``org.xml.sax``, ``org.xmlpull.v1``, ``play.libs.ws``, ``play.mvc``, ``ratpack.core.form``, ``ratpack.core.handling``, ``ratpack.core.http``, ``ratpack.exec``, ``ratpack.form``, ``ratpack.func``, ``ratpack.handling``, ``ratpack.http``, ``ratpack.util``, ``software.amazon.awssdk.transfer.s3.model``, ``sun.jvmstat.perfdata.monitor.protocol.local``, ``sun.jvmstat.perfdata.monitor.protocol.rmi``, ``sun.misc``, ``sun.net.ftp``, ``sun.net.www.protocol.http``, ``sun.security.acl``, ``sun.security.jgss.krb5``, ``sun.security.krb5``, ``sun.security.pkcs``, ``sun.security.pkcs11``, ``sun.security.provider``, ``sun.security.ssl``, ``sun.security.x509``, ``sun.tools.jconsole``",108,6034,757,131,6,14,18,,185
   Totals,,363,26381,2681,404,16,134,33,1,409

