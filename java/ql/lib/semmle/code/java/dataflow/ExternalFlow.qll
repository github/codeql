/**
 * INTERNAL use only. This is an experimental API subject to change without notice.
 *
 * Provides classes and predicates for dealing with flow models specified in CSV format.
 *
 * The CSV specification has the following columns:
 * - Sources:
 *   `namespace; type; subtypes; name; signature; ext; output; kind; provenance`
 * - Sinks:
 *   `namespace; type; subtypes; name; signature; ext; input; kind; provenance`
 * - Summaries:
 *   `namespace; type; subtypes; name; signature; ext; input; output; kind; provenance`
 * - Negative Summaries:
 *   `namespace; type; name; signature; provenance`
 *
 * The interpretation of a row is similar to API-graphs with a left-to-right
 * reading.
 * 1. The `namespace` column selects a package.
 * 2. The `type` column selects a type within that package.
 * 3. The `subtypes` is a boolean that indicates whether to jump to an
 *    arbitrary subtype of that type.
 * 4. The `name` column optionally selects a specific named member of the type.
 * 5. The `signature` column optionally restricts the named member. If
 *    `signature` is blank then no such filtering is done. The format of the
 *    signature is a comma-separated list of types enclosed in parentheses. The
 *    types can be short names or fully qualified names (mixing these two options
 *    is not allowed within a single signature).
 * 6. The `ext` column specifies additional API-graph-like edges. Currently
 *    there are only two valid values: "" and "Annotated". The empty string has no
 *    effect. "Annotated" applies if `name` and `signature` were left blank and
 *    acts by selecting an element that is annotated by the annotation type
 *    selected by the first 4 columns. This can be another member such as a field
 *    or method, or a parameter.
 * 7. The `input` column specifies how data enters the element selected by the
 *    first 6 columns, and the `output` column specifies how data leaves the
 *    element selected by the first 6 columns. An `input` can be either "",
 *    "Argument[n]", "Argument[n1..n2]", "ReturnValue":
 *    - "": Selects a write to the selected element in case this is a field.
 *    - "Argument[n]": Selects an argument in a call to the selected element.
 *      The arguments are zero-indexed, and `-1` specifies the qualifier.
 *    - "Argument[n1..n2]": Similar to "Argument[n]" but select any argument in
 *      the given range. The range is inclusive at both ends.
 *    - "ReturnValue": Selects a value being returned by the selected element.
 *      This requires that the selected element is a method with a body.
 *
 *    An `output` can be either "", "Argument[n]", "Argument[n1..n2]", "Parameter",
 *    "Parameter[n]", "Parameter[n1..n2]", or "ReturnValue":
 *    - "": Selects a read of a selected field, or a selected parameter.
 *    - "Argument[n]": Selects the post-update value of an argument in a call to the
 *      selected element. That is, the value of the argument after the call returns.
 *      The arguments are zero-indexed, and `-1` specifies the qualifier.
 *    - "Argument[n1..n2]": Similar to "Argument[n]" but select any argument in
 *      the given range. The range is inclusive at both ends.
 *    - "Parameter": Selects the value of a parameter of the selected element.
 *      "Parameter" is also allowed in case the selected element is already a
 *      parameter itself.
 *    - "Parameter[n]": Similar to "Parameter" but restricted to a specific
 *      numbered parameter (zero-indexed, and `-1` specifies the value of `this`).
 *    - "Parameter[n1..n2]": Similar to "Parameter[n]" but selects any parameter
 *      in the given range. The range is inclusive at both ends.
 *    - "ReturnValue": Selects the return value of a call to the selected element.
 * 8. The `kind` column is a tag that can be referenced from QL to determine to
 *    which classes the interpreted elements should be added. For example, for
 *    sources "remote" indicates a default remote flow source, and for summaries
 *    "taint" indicates a default additional taint step and "value" indicates a
 *    globally applicable value-preserving step.
 * 9. The `provenance` column is a tag to indicate the origin of the summary.
 *    There are two supported values: "generated" and "manual". "generated" means that
 *    the model has been emitted by the model generator tool and "manual" means
 *    that the model has been written by hand.
 */

import java
private import semmle.code.java.dataflow.DataFlow::DataFlow
private import internal.DataFlowPrivate
private import internal.FlowSummaryImpl::Private::External
private import internal.FlowSummaryImplSpecific
private import internal.AccessPathSyntax
private import FlowSummary

/**
 * A module importing the frameworks that provide external flow data,
 * ensuring that they are visible to the taint tracking / data flow library.
 */
private module Frameworks {
  private import internal.ContainerFlow
  private import semmle.code.java.frameworks.android.Android
  private import semmle.code.java.frameworks.android.ContentProviders
  private import semmle.code.java.frameworks.android.ExternalStorage
  private import semmle.code.java.frameworks.android.Intent
  private import semmle.code.java.frameworks.android.Notifications
  private import semmle.code.java.frameworks.android.SharedPreferences
  private import semmle.code.java.frameworks.android.Slice
  private import semmle.code.java.frameworks.android.SQLite
  private import semmle.code.java.frameworks.android.Widget
  private import semmle.code.java.frameworks.android.XssSinks
  private import semmle.code.java.frameworks.ApacheHttp
  private import semmle.code.java.frameworks.apache.Collections
  private import semmle.code.java.frameworks.apache.IO
  private import semmle.code.java.frameworks.apache.Lang
  private import semmle.code.java.frameworks.Flexjson
  private import semmle.code.java.frameworks.generated
  private import semmle.code.java.frameworks.guava.Guava
  private import semmle.code.java.frameworks.jackson.JacksonSerializability
  private import semmle.code.java.frameworks.javaee.jsf.JSFRenderer
  private import semmle.code.java.frameworks.JavaIo
  private import semmle.code.java.frameworks.JavaxJson
  private import semmle.code.java.frameworks.JaxWS
  private import semmle.code.java.frameworks.JoddJson
  private import semmle.code.java.frameworks.JsonJava
  private import semmle.code.java.frameworks.Logging
  private import semmle.code.java.frameworks.Objects
  private import semmle.code.java.frameworks.OkHttp
  private import semmle.code.java.frameworks.Optional
  private import semmle.code.java.frameworks.Regex
  private import semmle.code.java.frameworks.Retrofit
  private import semmle.code.java.frameworks.Stream
  private import semmle.code.java.frameworks.Strings
  private import semmle.code.java.frameworks.ratpack.Ratpack
  private import semmle.code.java.frameworks.ratpack.RatpackExec
  private import semmle.code.java.frameworks.spring.SpringCache
  private import semmle.code.java.frameworks.spring.SpringContext
  private import semmle.code.java.frameworks.spring.SpringHttp
  private import semmle.code.java.frameworks.spring.SpringUtil
  private import semmle.code.java.frameworks.spring.SpringUi
  private import semmle.code.java.frameworks.spring.SpringValidation
  private import semmle.code.java.frameworks.spring.SpringWebClient
  private import semmle.code.java.frameworks.spring.SpringBeans
  private import semmle.code.java.frameworks.spring.SpringWebMultipart
  private import semmle.code.java.frameworks.spring.SpringWebUtil
  private import semmle.code.java.security.AndroidIntentRedirection
  private import semmle.code.java.security.ResponseSplitting
  private import semmle.code.java.security.InformationLeak
  private import semmle.code.java.security.Files
  private import semmle.code.java.security.GroovyInjection
  private import semmle.code.java.security.ImplicitPendingIntents
  private import semmle.code.java.security.JexlInjectionSinkModels
  private import semmle.code.java.security.JndiInjection
  private import semmle.code.java.security.LdapInjection
  private import semmle.code.java.security.MvelInjection
  private import semmle.code.java.security.OgnlInjection
  private import semmle.code.java.security.XPath
  private import semmle.code.java.security.XsltInjection
  private import semmle.code.java.frameworks.Jdbc
  private import semmle.code.java.frameworks.Jdbi
  private import semmle.code.java.frameworks.HikariCP
  private import semmle.code.java.frameworks.SpringJdbc
  private import semmle.code.java.frameworks.MyBatis
  private import semmle.code.java.frameworks.Hibernate
  private import semmle.code.java.frameworks.jOOQ
  private import semmle.code.java.frameworks.JMS
  private import semmle.code.java.frameworks.RabbitMQ
  private import semmle.code.java.regex.RegexFlowModels
  private import semmle.code.java.frameworks.KotlinStdLib
}

/**
 * A unit class for adding additional source model rows.
 *
 * Extend this class to add additional source definitions.
 */
class SourceModelCsv extends Unit {
  /** Holds if `row` specifies a source definition. */
  abstract predicate row(string row);
}

/**
 * A unit class for adding additional sink model rows.
 *
 * Extend this class to add additional sink definitions.
 */
class SinkModelCsv extends Unit {
  /** Holds if `row` specifies a sink definition. */
  abstract predicate row(string row);
}

/**
 * A unit class for adding additional summary model rows.
 *
 * Extend this class to add additional flow summary definitions.
 */
class SummaryModelCsv extends Unit {
  /** Holds if `row` specifies a summary definition. */
  abstract predicate row(string row);
}

/**
 * A unit class for adding negative summary model rows.
 *
 * Extend this class to add additional flow summary definitions.
 */
class NegativeSummaryModelCsv extends Unit {
  /** Holds if `row` specifies a negative summary definition. */
  abstract predicate row(string row);
}

private class SourceModelCsvBase extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        // org.springframework.security.web.savedrequest.SavedRequest
        "org.springframework.security.web.savedrequest;SavedRequest;true;getRedirectUrl;;;ReturnValue;remote;manual",
        "org.springframework.security.web.savedrequest;SavedRequest;true;getCookies;;;ReturnValue;remote;manual",
        "org.springframework.security.web.savedrequest;SavedRequest;true;getHeaderValues;;;ReturnValue;remote;manual",
        "org.springframework.security.web.savedrequest;SavedRequest;true;getHeaderNames;;;ReturnValue;remote;manual",
        "org.springframework.security.web.savedrequest;SavedRequest;true;getParameterValues;;;ReturnValue;remote;manual",
        "org.springframework.security.web.savedrequest;SavedRequest;true;getParameterMap;;;ReturnValue;remote;manual",
        // ServletRequestGetParameterMethod
        "javax.servlet;ServletRequest;false;getParameter;(String);;ReturnValue;remote;manual",
        "javax.servlet;ServletRequest;false;getParameterValues;(String);;ReturnValue;remote;manual",
        "javax.servlet.http;HttpServletRequest;false;getParameter;(String);;ReturnValue;remote;manual",
        "javax.servlet.http;HttpServletRequest;false;getParameterValues;(String);;ReturnValue;remote;manual",
        // ServletRequestGetParameterMapMethod
        "javax.servlet;ServletRequest;false;getParameterMap;();;ReturnValue;remote;manual",
        "javax.servlet.http;HttpServletRequest;false;getParameterMap;();;ReturnValue;remote;manual",
        // ServletRequestGetParameterNamesMethod
        "javax.servlet;ServletRequest;false;getParameterNames;();;ReturnValue;remote;manual",
        "javax.servlet.http;HttpServletRequest;false;getParameterNames;();;ReturnValue;remote;manual",
        // HttpServletRequestGetQueryStringMethod
        "javax.servlet.http;HttpServletRequest;false;getQueryString;();;ReturnValue;remote;manual",
        //
        // URLConnectionGetInputStreamMethod
        "java.net;URLConnection;false;getInputStream;();;ReturnValue;remote;manual",
        // SocketGetInputStreamMethod
        "java.net;Socket;false;getInputStream;();;ReturnValue;remote;manual",
        // BeanValidationSource
        "javax.validation;ConstraintValidator;true;isValid;;;Parameter[0];remote;manual",
        // SpringMultipartRequestSource
        "org.springframework.web.multipart;MultipartRequest;true;getFile;(String);;ReturnValue;remote;manual",
        "org.springframework.web.multipart;MultipartRequest;true;getFileMap;();;ReturnValue;remote;manual",
        "org.springframework.web.multipart;MultipartRequest;true;getFileNames;();;ReturnValue;remote;manual",
        "org.springframework.web.multipart;MultipartRequest;true;getFiles;(String);;ReturnValue;remote;manual",
        "org.springframework.web.multipart;MultipartRequest;true;getMultiFileMap;();;ReturnValue;remote;manual",
        "org.springframework.web.multipart;MultipartRequest;true;getMultipartContentType;(String);;ReturnValue;remote;manual",
        // SpringMultipartFileSource
        "org.springframework.web.multipart;MultipartFile;true;getBytes;();;ReturnValue;remote;manual",
        "org.springframework.web.multipart;MultipartFile;true;getContentType;();;ReturnValue;remote;manual",
        "org.springframework.web.multipart;MultipartFile;true;getInputStream;();;ReturnValue;remote;manual",
        "org.springframework.web.multipart;MultipartFile;true;getName;();;ReturnValue;remote;manual",
        "org.springframework.web.multipart;MultipartFile;true;getOriginalFilename;();;ReturnValue;remote;manual",
        "org.springframework.web.multipart;MultipartFile;true;getResource;();;ReturnValue;remote;manual",
        // HttpServletRequest.get*
        "javax.servlet.http;HttpServletRequest;false;getHeader;(String);;ReturnValue;remote;manual",
        "javax.servlet.http;HttpServletRequest;false;getHeaders;(String);;ReturnValue;remote;manual",
        "javax.servlet.http;HttpServletRequest;false;getHeaderNames;();;ReturnValue;remote;manual",
        "javax.servlet.http;HttpServletRequest;false;getPathInfo;();;ReturnValue;remote;manual",
        "javax.servlet.http;HttpServletRequest;false;getRequestURI;();;ReturnValue;remote;manual",
        "javax.servlet.http;HttpServletRequest;false;getRequestURL;();;ReturnValue;remote;manual",
        "javax.servlet.http;HttpServletRequest;false;getRemoteUser;();;ReturnValue;remote;manual",
        // SpringWebRequestGetMethod
        "org.springframework.web.context.request;WebRequest;false;getDescription;;;ReturnValue;remote;manual",
        "org.springframework.web.context.request;WebRequest;false;getHeader;;;ReturnValue;remote;manual",
        "org.springframework.web.context.request;WebRequest;false;getHeaderNames;;;ReturnValue;remote;manual",
        "org.springframework.web.context.request;WebRequest;false;getHeaderValues;;;ReturnValue;remote;manual",
        "org.springframework.web.context.request;WebRequest;false;getParameter;;;ReturnValue;remote;manual",
        "org.springframework.web.context.request;WebRequest;false;getParameterMap;;;ReturnValue;remote;manual",
        "org.springframework.web.context.request;WebRequest;false;getParameterNames;;;ReturnValue;remote;manual",
        "org.springframework.web.context.request;WebRequest;false;getParameterValues;;;ReturnValue;remote;manual",
        // TODO consider org.springframework.web.context.request.WebRequest.getRemoteUser
        // ServletRequestGetBodyMethod
        "javax.servlet;ServletRequest;false;getInputStream;();;ReturnValue;remote;manual",
        "javax.servlet;ServletRequest;false;getReader;();;ReturnValue;remote;manual",
        // CookieGet*
        "javax.servlet.http;Cookie;false;getValue;();;ReturnValue;remote;manual",
        "javax.servlet.http;Cookie;false;getName;();;ReturnValue;remote;manual",
        "javax.servlet.http;Cookie;false;getComment;();;ReturnValue;remote;manual",
        // ApacheHttp*
        "org.apache.http;HttpMessage;false;getParams;();;ReturnValue;remote;manual",
        "org.apache.http;HttpEntity;false;getContent;();;ReturnValue;remote;manual",
        // In the setting of Android we assume that XML has been transmitted over
        // the network, so may be tainted.
        // XmlPullGetMethod
        "org.xmlpull.v1;XmlPullParser;false;getName;();;ReturnValue;remote;manual",
        "org.xmlpull.v1;XmlPullParser;false;getNamespace;();;ReturnValue;remote;manual",
        "org.xmlpull.v1;XmlPullParser;false;getText;();;ReturnValue;remote;manual",
        // XmlAttrSetGetMethod
        "android.util;AttributeSet;false;getAttributeBooleanValue;;;ReturnValue;remote;manual",
        "android.util;AttributeSet;false;getAttributeCount;;;ReturnValue;remote;manual",
        "android.util;AttributeSet;false;getAttributeFloatValue;;;ReturnValue;remote;manual",
        "android.util;AttributeSet;false;getAttributeIntValue;;;ReturnValue;remote;manual",
        "android.util;AttributeSet;false;getAttributeListValue;;;ReturnValue;remote;manual",
        "android.util;AttributeSet;false;getAttributeName;;;ReturnValue;remote;manual",
        "android.util;AttributeSet;false;getAttributeNameResource;;;ReturnValue;remote;manual",
        "android.util;AttributeSet;false;getAttributeNamespace;;;ReturnValue;remote;manual",
        "android.util;AttributeSet;false;getAttributeResourceValue;;;ReturnValue;remote;manual",
        "android.util;AttributeSet;false;getAttributeUnsignedIntValue;;;ReturnValue;remote;manual",
        "android.util;AttributeSet;false;getAttributeValue;;;ReturnValue;remote;manual",
        "android.util;AttributeSet;false;getClassAttribute;;;ReturnValue;remote;manual",
        "android.util;AttributeSet;false;getIdAttribute;;;ReturnValue;remote;manual",
        "android.util;AttributeSet;false;getIdAttributeResourceValue;;;ReturnValue;remote;manual",
        "android.util;AttributeSet;false;getPositionDescription;;;ReturnValue;remote;manual",
        "android.util;AttributeSet;false;getStyleAttribute;;;ReturnValue;remote;manual",
        // The current URL in a browser may be untrusted or uncontrolled.
        // WebViewGetUrlMethod
        "android.webkit;WebView;false;getUrl;();;ReturnValue;remote;manual",
        "android.webkit;WebView;false;getOriginalUrl;();;ReturnValue;remote;manual",
        // SpringRestTemplateResponseEntityMethod
        "org.springframework.web.client;RestTemplate;false;exchange;;;ReturnValue;remote;manual",
        "org.springframework.web.client;RestTemplate;false;getForEntity;;;ReturnValue;remote;manual",
        "org.springframework.web.client;RestTemplate;false;postForEntity;;;ReturnValue;remote;manual",
        // WebSocketMessageParameterSource
        "java.net.http;WebSocket$Listener;true;onText;(WebSocket,CharSequence,boolean);;Parameter[1];remote;manual",
        // PlayRequestGetMethod
        "play.mvc;Http$RequestHeader;false;queryString;;;ReturnValue;remote;manual",
        "play.mvc;Http$RequestHeader;false;getQueryString;;;ReturnValue;remote;manual",
        "play.mvc;Http$RequestHeader;false;header;;;ReturnValue;remote;manual",
        "play.mvc;Http$RequestHeader;false;getHeader;;;ReturnValue;remote;manual"
      ]
  }
}

private class SinkModelCsvBase extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        // Open URL
        "java.net;URL;false;openConnection;;;Argument[-1];open-url;manual",
        "java.net;URL;false;openStream;;;Argument[-1];open-url;manual",
        "java.net.http;HttpRequest;false;newBuilder;;;Argument[0];open-url;manual",
        "java.net.http;HttpRequest$Builder;false;uri;;;Argument[0];open-url;manual",
        "java.net;URLClassLoader;false;URLClassLoader;(URL[]);;Argument[0];open-url;manual",
        "java.net;URLClassLoader;false;URLClassLoader;(URL[],ClassLoader);;Argument[0];open-url;manual",
        "java.net;URLClassLoader;false;URLClassLoader;(URL[],ClassLoader,URLStreamHandlerFactory);;Argument[0];open-url;manual",
        "java.net;URLClassLoader;false;URLClassLoader;(String,URL[],ClassLoader);;Argument[1];open-url;manual",
        "java.net;URLClassLoader;false;URLClassLoader;(String,URL[],ClassLoader,URLStreamHandlerFactory);;Argument[1];open-url;manual",
        "java.net;URLClassLoader;false;newInstance;;;Argument[0];open-url;manual",
        // Bean validation
        "javax.validation;ConstraintValidatorContext;true;buildConstraintViolationWithTemplate;;;Argument[0];bean-validation;manual",
        // Set hostname
        "javax.net.ssl;HttpsURLConnection;true;setDefaultHostnameVerifier;;;Argument[0];set-hostname-verifier;manual",
        "javax.net.ssl;HttpsURLConnection;true;setHostnameVerifier;;;Argument[0];set-hostname-verifier;manual"
      ]
  }
}

private class SummaryModelCsvBase extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        // qualifier to arg
        "java.io;InputStream;true;read;(byte[]);;Argument[-1];Argument[0];taint;manual",
        "java.io;InputStream;true;read;(byte[],int,int);;Argument[-1];Argument[0];taint;manual",
        "java.io;InputStream;true;readNBytes;(byte[],int,int);;Argument[-1];Argument[0];taint;manual",
        "java.io;InputStream;true;transferTo;(OutputStream);;Argument[-1];Argument[0];taint;manual",
        "java.io;ByteArrayOutputStream;false;writeTo;;;Argument[-1];Argument[0];taint;manual",
        "java.io;Reader;true;read;;;Argument[-1];Argument[0];taint;manual",
        // qualifier to return
        "java.io;ByteArrayOutputStream;false;toByteArray;;;Argument[-1];ReturnValue;taint;manual",
        "java.io;ByteArrayOutputStream;false;toString;;;Argument[-1];ReturnValue;taint;manual",
        "java.io;InputStream;true;readAllBytes;;;Argument[-1];ReturnValue;taint;manual",
        "java.io;InputStream;true;readNBytes;(int);;Argument[-1];ReturnValue;taint;manual",
        "java.util;StringTokenizer;false;nextElement;();;Argument[-1];ReturnValue;taint;manual",
        "java.util;StringTokenizer;false;nextToken;;;Argument[-1];ReturnValue;taint;manual",
        "javax.xml.transform.sax;SAXSource;false;getInputSource;;;Argument[-1];ReturnValue;taint;manual",
        "javax.xml.transform.stream;StreamSource;false;getInputStream;;;Argument[-1];ReturnValue;taint;manual",
        "java.nio;ByteBuffer;false;get;;;Argument[-1];ReturnValue;taint;manual",
        "java.net;URI;false;toURL;;;Argument[-1];ReturnValue;taint;manual",
        "java.net;URI;false;toString;;;Argument[-1];ReturnValue;taint;manual",
        "java.net;URI;false;toAsciiString;;;Argument[-1];ReturnValue;taint;manual",
        "java.io;File;true;toURI;;;Argument[-1];ReturnValue;taint;manual",
        "java.io;File;true;toPath;;;Argument[-1];ReturnValue;taint;manual",
        "java.io;File;true;getAbsoluteFile;;;Argument[-1];ReturnValue;taint;manual",
        "java.io;File;true;getCanonicalFile;;;Argument[-1];ReturnValue;taint;manual",
        "java.io;File;true;getAbsolutePath;;;Argument[-1];ReturnValue;taint;manual",
        "java.io;File;true;getCanonicalPath;;;Argument[-1];ReturnValue;taint;manual",
        "java.nio;ByteBuffer;false;array;();;Argument[-1];ReturnValue;taint;manual",
        "java.nio.file;Path;true;normalize;;;Argument[-1];ReturnValue;taint;manual",
        "java.nio.file;Path;true;resolve;;;Argument[-1..0];ReturnValue;taint;manual",
        "java.nio.file;Path;false;toFile;;;Argument[-1];ReturnValue;taint;manual",
        "java.nio.file;Path;true;toString;;;Argument[-1];ReturnValue;taint;manual",
        "java.nio.file;Path;true;toUri;;;Argument[-1];ReturnValue;taint;manual",
        "java.nio.file;Paths;true;get;;;Argument[0..1];ReturnValue;taint;manual",
        "java.io;BufferedReader;true;readLine;;;Argument[-1];ReturnValue;taint;manual",
        "java.io;Reader;true;read;();;Argument[-1];ReturnValue;taint;manual",
        // arg to return
        "java.nio;ByteBuffer;false;wrap;(byte[]);;Argument[0];ReturnValue;taint;manual",
        "java.util;Base64$Encoder;false;encode;(byte[]);;Argument[0];ReturnValue;taint;manual",
        "java.util;Base64$Encoder;false;encode;(ByteBuffer);;Argument[0];ReturnValue;taint;manual",
        "java.util;Base64$Encoder;false;encodeToString;(byte[]);;Argument[0];ReturnValue;taint;manual",
        "java.util;Base64$Encoder;false;wrap;(OutputStream);;Argument[0];ReturnValue;taint;manual",
        "java.util;Base64$Decoder;false;decode;(byte[]);;Argument[0];ReturnValue;taint;manual",
        "java.util;Base64$Decoder;false;decode;(ByteBuffer);;Argument[0];ReturnValue;taint;manual",
        "java.util;Base64$Decoder;false;decode;(String);;Argument[0];ReturnValue;taint;manual",
        "java.util;Base64$Decoder;false;wrap;(InputStream);;Argument[0];ReturnValue;taint;manual",
        "cn.hutool.core.codec;Base64;true;decode;;;Argument[0];ReturnValue;taint;manual",
        "org.apache.shiro.codec;Base64;false;decode;(String);;Argument[0];ReturnValue;taint;manual",
        "org.apache.commons.codec;Encoder;true;encode;(Object);;Argument[0];ReturnValue;taint;manual",
        "org.apache.commons.codec;Decoder;true;decode;(Object);;Argument[0];ReturnValue;taint;manual",
        "org.apache.commons.codec;BinaryEncoder;true;encode;(byte[]);;Argument[0];ReturnValue;taint;manual",
        "org.apache.commons.codec;BinaryDecoder;true;decode;(byte[]);;Argument[0];ReturnValue;taint;manual",
        "org.apache.commons.codec;StringEncoder;true;encode;(String);;Argument[0];ReturnValue;taint;manual",
        "org.apache.commons.codec;StringDecoder;true;decode;(String);;Argument[0];ReturnValue;taint;manual",
        "java.net;URLDecoder;false;decode;;;Argument[0];ReturnValue;taint;manual",
        "java.net;URI;false;create;;;Argument[0];ReturnValue;taint;manual",
        "javax.xml.transform.sax;SAXSource;false;sourceToInputSource;;;Argument[0];ReturnValue;taint;manual",
        // arg to arg
        "java.lang;System;false;arraycopy;;;Argument[0];Argument[2];taint;manual",
        // constructor flow
        "java.io;File;false;File;;;Argument[0];Argument[-1];taint;manual",
        "java.io;File;false;File;;;Argument[1];Argument[-1];taint;manual",
        "java.net;URI;false;URI;(String);;Argument[0];Argument[-1];taint;manual",
        "java.net;URL;false;URL;(String);;Argument[0];Argument[-1];taint;manual",
        "javax.xml.transform.stream;StreamSource;false;StreamSource;;;Argument[0];Argument[-1];taint;manual",
        "javax.xml.transform.sax;SAXSource;false;SAXSource;(InputSource);;Argument[0];Argument[-1];taint;manual",
        "javax.xml.transform.sax;SAXSource;false;SAXSource;(XMLReader,InputSource);;Argument[1];Argument[-1];taint;manual",
        "org.xml.sax;InputSource;false;InputSource;;;Argument[0];Argument[-1];taint;manual",
        "javax.servlet.http;Cookie;false;Cookie;;;Argument[0];Argument[-1];taint;manual",
        "javax.servlet.http;Cookie;false;Cookie;;;Argument[1];Argument[-1];taint;manual",
        "java.util.zip;ZipInputStream;false;ZipInputStream;;;Argument[0];Argument[-1];taint;manual",
        "java.util.zip;GZIPInputStream;false;GZIPInputStream;;;Argument[0];Argument[-1];taint;manual",
        "java.util;StringTokenizer;false;StringTokenizer;;;Argument[0];Argument[-1];taint;manual",
        "java.beans;XMLDecoder;false;XMLDecoder;;;Argument[0];Argument[-1];taint;manual",
        "com.esotericsoftware.kryo.io;Input;false;Input;;;Argument[0];Argument[-1];taint;manual",
        "com.esotericsoftware.kryo5.io;Input;false;Input;;;Argument[0];Argument[-1];taint;manual",
        "java.io;BufferedInputStream;false;BufferedInputStream;;;Argument[0];Argument[-1];taint;manual",
        "java.io;DataInputStream;false;DataInputStream;;;Argument[0];Argument[-1];taint;manual",
        "java.io;ByteArrayInputStream;false;ByteArrayInputStream;;;Argument[0];Argument[-1];taint;manual",
        "java.io;ObjectInputStream;false;ObjectInputStream;;;Argument[0];Argument[-1];taint;manual",
        "java.io;StringReader;false;StringReader;;;Argument[0];Argument[-1];taint;manual",
        "java.io;CharArrayReader;false;CharArrayReader;;;Argument[0];Argument[-1];taint;manual",
        "java.io;BufferedReader;false;BufferedReader;;;Argument[0];Argument[-1];taint;manual",
        "java.io;InputStreamReader;false;InputStreamReader;;;Argument[0];Argument[-1];taint;manual",
        "java.io;OutputStream;true;write;(byte[]);;Argument[0];Argument[-1];taint;manual",
        "java.io;OutputStream;true;write;(byte[],int,int);;Argument[0];Argument[-1];taint;manual",
        "java.io;OutputStream;true;write;(int);;Argument[0];Argument[-1];taint;manual",
        "java.io;FilterOutputStream;true;FilterOutputStream;(OutputStream);;Argument[0];Argument[-1];taint;manual"
      ]
  }
}

/** Holds if `row` is a source model. */
predicate sourceModel(string row) { any(SourceModelCsv s).row(row) }

/** Holds if `row` is a sink model. */
predicate sinkModel(string row) { any(SinkModelCsv s).row(row) }

/** Holds if `row` is a summary model. */
predicate summaryModel(string row) { any(SummaryModelCsv s).row(row) }

/** Holds if `row` is negative summary model. */
predicate negativeSummaryModel(string row) { any(NegativeSummaryModelCsv s).row(row) }

/** Holds if a source model exists for the given parameters. */
predicate sourceModel(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string output, string kind, string provenance
) {
  exists(string row |
    sourceModel(row) and
    row.splitAt(";", 0) = namespace and
    row.splitAt(";", 1) = type and
    row.splitAt(";", 2) = subtypes.toString() and
    subtypes = [true, false] and
    row.splitAt(";", 3) = name and
    row.splitAt(";", 4) = signature and
    row.splitAt(";", 5) = ext and
    row.splitAt(";", 6) = output and
    row.splitAt(";", 7) = kind and
    row.splitAt(";", 8) = provenance
  )
}

/** Holds if a sink model exists for the given parameters. */
predicate sinkModel(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string input, string kind, string provenance
) {
  exists(string row |
    sinkModel(row) and
    row.splitAt(";", 0) = namespace and
    row.splitAt(";", 1) = type and
    row.splitAt(";", 2) = subtypes.toString() and
    subtypes = [true, false] and
    row.splitAt(";", 3) = name and
    row.splitAt(";", 4) = signature and
    row.splitAt(";", 5) = ext and
    row.splitAt(";", 6) = input and
    row.splitAt(";", 7) = kind and
    row.splitAt(";", 8) = provenance
  )
}

/** Holds if a summary model exists for the given parameters. */
predicate summaryModel(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string input, string output, string kind, string provenance
) {
  summaryModel(namespace, type, subtypes, name, signature, ext, input, output, kind, provenance, _)
}

/** Holds if a summary model `row` exists for the given parameters. */
predicate summaryModel(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string input, string output, string kind, string provenance, string row
) {
  summaryModel(row) and
  row.splitAt(";", 0) = namespace and
  row.splitAt(";", 1) = type and
  row.splitAt(";", 2) = subtypes.toString() and
  subtypes = [true, false] and
  row.splitAt(";", 3) = name and
  row.splitAt(";", 4) = signature and
  row.splitAt(";", 5) = ext and
  row.splitAt(";", 6) = input and
  row.splitAt(";", 7) = output and
  row.splitAt(";", 8) = kind and
  row.splitAt(";", 9) = provenance
}

/** Holds if a summary model exists indicating there is no flow for the given parameters. */
predicate negativeSummaryModel(
  string namespace, string type, string name, string signature, string provenance
) {
  exists(string row |
    negativeSummaryModel(row) and
    row.splitAt(";", 0) = namespace and
    row.splitAt(";", 1) = type and
    row.splitAt(";", 2) = name and
    row.splitAt(";", 3) = signature and
    row.splitAt(";", 4) = provenance
  )
}

private predicate relevantPackage(string package) {
  sourceModel(package, _, _, _, _, _, _, _, _) or
  sinkModel(package, _, _, _, _, _, _, _, _) or
  summaryModel(package, _, _, _, _, _, _, _, _, _, _)
}

private predicate packageLink(string shortpkg, string longpkg) {
  relevantPackage(shortpkg) and
  relevantPackage(longpkg) and
  longpkg.prefix(longpkg.indexOf(".")) = shortpkg
}

private predicate canonicalPackage(string package) {
  relevantPackage(package) and not packageLink(_, package)
}

private predicate canonicalPkgLink(string package, string subpkg) {
  canonicalPackage(package) and
  (subpkg = package or packageLink(package, subpkg))
}

/**
 * Holds if CSV framework coverage of `package` is `n` api endpoints of the
 * kind `(kind, part)`.
 */
predicate modelCoverage(string package, int pkgs, string kind, string part, int n) {
  pkgs = strictcount(string subpkg | canonicalPkgLink(package, subpkg)) and
  (
    part = "source" and
    n =
      strictcount(string subpkg, string type, boolean subtypes, string name, string signature,
        string ext, string output, string provenance |
        canonicalPkgLink(package, subpkg) and
        sourceModel(subpkg, type, subtypes, name, signature, ext, output, kind, provenance)
      )
    or
    part = "sink" and
    n =
      strictcount(string subpkg, string type, boolean subtypes, string name, string signature,
        string ext, string input, string provenance |
        canonicalPkgLink(package, subpkg) and
        sinkModel(subpkg, type, subtypes, name, signature, ext, input, kind, provenance)
      )
    or
    part = "summary" and
    n =
      strictcount(string subpkg, string type, boolean subtypes, string name, string signature,
        string ext, string input, string output, string provenance |
        canonicalPkgLink(package, subpkg) and
        summaryModel(subpkg, type, subtypes, name, signature, ext, input, output, kind, provenance)
      )
  )
}

/** Provides a query predicate to check the CSV data for validation errors. */
module CsvValidation {
  private string getInvalidModelInput() {
    exists(string pred, string input, string part |
      sinkModel(_, _, _, _, _, _, input, _, _) and pred = "sink"
      or
      summaryModel(_, _, _, _, _, _, input, _, _, _) and pred = "summary"
    |
      (
        invalidSpecComponent(input, part) and
        not part = "" and
        not (part = "Argument" and pred = "sink") and
        not parseArg(part, _)
        or
        part = input.(AccessPath).getToken(0) and
        parseParam(part, _)
      ) and
      result = "Unrecognized input specification \"" + part + "\" in " + pred + " model."
    )
  }

  private string getInvalidModelOutput() {
    exists(string pred, string output, string part |
      sourceModel(_, _, _, _, _, _, output, _, _) and pred = "source"
      or
      summaryModel(_, _, _, _, _, _, _, output, _, _) and pred = "summary"
    |
      invalidSpecComponent(output, part) and
      not part = "" and
      not (part = ["Argument", "Parameter"] and pred = "source") and
      result = "Unrecognized output specification \"" + part + "\" in " + pred + " model."
    )
  }

  private string getInvalidModelKind() {
    exists(string row, string kind | summaryModel(row) |
      kind = row.splitAt(";", 8) and
      not kind = ["taint", "value"] and
      result = "Invalid kind \"" + kind + "\" in summary model."
    )
    or
    exists(string row, string kind | sinkModel(row) |
      kind = row.splitAt(";", 7) and
      not kind =
        [
          "open-url", "jndi-injection", "ldap", "sql", "jdbc-url", "logging", "mvel", "xpath",
          "groovy", "xss", "ognl-injection", "intent-start", "pending-intent-sent",
          "url-open-stream", "url-redirect", "create-file", "write-file", "set-hostname-verifier",
          "header-splitting", "information-leak", "xslt", "jexl", "bean-validation"
        ] and
      not kind.matches("regex-use%") and
      not kind.matches("qltest%") and
      result = "Invalid kind \"" + kind + "\" in sink model."
    )
    or
    exists(string row, string kind | sourceModel(row) |
      kind = row.splitAt(";", 7) and
      not kind = ["remote", "contentprovider", "android-widget", "android-external-storage-dir"] and
      not kind.matches("qltest%") and
      result = "Invalid kind \"" + kind + "\" in source model."
    )
  }

  private string getInvalidModelSubtype() {
    exists(string pred, string row |
      sourceModel(row) and pred = "source"
      or
      sinkModel(row) and pred = "sink"
      or
      summaryModel(row) and pred = "summary"
    |
      exists(string b |
        b = row.splitAt(";", 2) and
        not b = ["true", "false"] and
        result = "Invalid boolean \"" + b + "\" in " + pred + " model."
      )
    )
  }

  private string getInvalidModelColumnCount() {
    exists(string pred, string row, int expect |
      sourceModel(row) and expect = 9 and pred = "source"
      or
      sinkModel(row) and expect = 9 and pred = "sink"
      or
      summaryModel(row) and expect = 10 and pred = "summary"
      or
      negativeSummaryModel(row) and expect = 5 and pred = "negative summary"
    |
      exists(int cols |
        cols = 1 + max(int n | exists(row.splitAt(";", n))) and
        cols != expect and
        result =
          "Wrong number of columns in " + pred + " model row, expected " + expect + ", got " + cols +
            " in " + row + "."
      )
    )
  }

  private string getInvalidModelSignature() {
    exists(
      string pred, string namespace, string type, string name, string signature, string ext,
      string provenance
    |
      sourceModel(namespace, type, _, name, signature, ext, _, _, provenance) and pred = "source"
      or
      sinkModel(namespace, type, _, name, signature, ext, _, _, provenance) and pred = "sink"
      or
      summaryModel(namespace, type, _, name, signature, ext, _, _, _, provenance) and
      pred = "summary"
      or
      negativeSummaryModel(namespace, type, name, signature, provenance) and
      ext = "" and
      pred = "negative summary"
    |
      not namespace.regexpMatch("[a-zA-Z0-9_\\.]+") and
      result = "Dubious namespace \"" + namespace + "\" in " + pred + " model."
      or
      not type.regexpMatch("[a-zA-Z0-9_\\$<>]+") and
      result = "Dubious type \"" + type + "\" in " + pred + " model."
      or
      not name.regexpMatch("[a-zA-Z0-9_]*") and
      result = "Dubious name \"" + name + "\" in " + pred + " model."
      or
      not signature.regexpMatch("|\\([a-zA-Z0-9_\\.\\$<>,\\[\\]]*\\)") and
      result = "Dubious signature \"" + signature + "\" in " + pred + " model."
      or
      not ext.regexpMatch("|Annotated") and
      result = "Unrecognized extra API graph element \"" + ext + "\" in " + pred + " model."
      or
      not provenance = ["manual", "generated"] and
      result = "Unrecognized provenance description \"" + provenance + "\" in " + pred + " model."
    )
  }

  /** Holds if some row in a CSV-based flow model appears to contain typos. */
  query predicate invalidModelRow(string msg) {
    msg =
      [
        getInvalidModelSignature(), getInvalidModelInput(), getInvalidModelOutput(),
        getInvalidModelSubtype(), getInvalidModelColumnCount(), getInvalidModelKind()
      ]
  }
}

pragma[nomagic]
private predicate elementSpec(
  string namespace, string type, boolean subtypes, string name, string signature, string ext
) {
  sourceModel(namespace, type, subtypes, name, signature, ext, _, _, _)
  or
  sinkModel(namespace, type, subtypes, name, signature, ext, _, _, _)
  or
  summaryModel(namespace, type, subtypes, name, signature, ext, _, _, _, _)
  or
  negativeSummaryModel(namespace, type, name, signature, _) and ext = "" and subtypes = false
}

private string paramsStringPart(Callable c, int i) {
  i = -1 and result = "("
  or
  exists(int n, string p | c.getParameterType(n).getErasure().toString() = p |
    i = 2 * n and result = p
    or
    i = 2 * n - 1 and result = "," and n != 0
  )
  or
  i = 2 * c.getNumberOfParameters() and result = ")"
}

/**
 * Gets a parenthesized string containing all parameter types of this callable, separated by a comma.
 *
 * Returns the empty string if the callable has no parameters.
 * Parameter types are represented by their type erasure.
 */
cached
string paramsString(Callable c) { result = concat(int i | | paramsStringPart(c, i) order by i) }

private Element interpretElement0(
  string namespace, string type, boolean subtypes, string name, string signature
) {
  elementSpec(namespace, type, subtypes, name, signature, _) and
  exists(RefType t | t.hasQualifiedName(namespace, type) |
    exists(Member m |
      (
        result = m
        or
        subtypes = true and result.(SrcMethod).overridesOrInstantiates+(m)
      ) and
      m.getDeclaringType() = t and
      m.hasName(name)
    |
      signature = "" or
      m.(Callable).getSignature() = any(string nameprefix) + signature or
      paramsString(m) = signature
    )
    or
    (if subtypes = true then result.(SrcRefType).getASourceSupertype*() = t else result = t) and
    name = "" and
    signature = ""
  )
}

/** Gets the source/sink/summary/negativesummary element corresponding to the supplied parameters. */
Element interpretElement(
  string namespace, string type, boolean subtypes, string name, string signature, string ext
) {
  elementSpec(namespace, type, subtypes, name, signature, ext) and
  exists(Element e | e = interpretElement0(namespace, type, subtypes, name, signature) |
    ext = "" and result = e
    or
    ext = "Annotated" and result.(Annotatable).getAnAnnotation().getType() = e
  )
}

private predicate parseField(AccessPathToken c, FieldContent f) {
  exists(
    string fieldRegex, string qualifiedName, string package, string className, string fieldName
  |
    c.getName() = "Field" and
    qualifiedName = c.getAnArgument() and
    fieldRegex = "^(.*)\\.([^.]+)\\.([^.]+)$" and
    package = qualifiedName.regexpCapture(fieldRegex, 1) and
    className = qualifiedName.regexpCapture(fieldRegex, 2) and
    fieldName = qualifiedName.regexpCapture(fieldRegex, 3) and
    f.getField().hasQualifiedName(package, className, fieldName)
  )
}

/** A string representing a synthetic instance field. */
class SyntheticField extends string {
  SyntheticField() { parseSynthField(_, this) }

  /**
   * Gets the type of this field. The default type is `Object`, but this can be
   * overridden.
   */
  Type getType() { result instanceof TypeObject }
}

private predicate parseSynthField(AccessPathToken c, string f) {
  c.getName() = "SyntheticField" and
  f = c.getAnArgument()
}

/** Holds if the specification component parses as a `Content`. */
predicate parseContent(AccessPathToken component, Content content) {
  parseField(component, content)
  or
  parseSynthField(component, content.(SyntheticFieldContent).getField())
  or
  component = "ArrayElement" and content instanceof ArrayContent
  or
  component = "Element" and content instanceof CollectionContent
  or
  component = "MapKey" and content instanceof MapKeyContent
  or
  component = "MapValue" and content instanceof MapValueContent
}

cached
private module Cached {
  /**
   * Holds if `node` is specified as a source with the given kind in a CSV flow
   * model.
   */
  cached
  predicate sourceNode(Node node, string kind) {
    exists(InterpretNode n | isSourceNode(n, kind) and n.asNode() = node)
  }

  /**
   * Holds if `node` is specified as a sink with the given kind in a CSV flow
   * model.
   */
  cached
  predicate sinkNode(Node node, string kind) {
    exists(InterpretNode n | isSinkNode(n, kind) and n.asNode() = node)
  }
}

import Cached
