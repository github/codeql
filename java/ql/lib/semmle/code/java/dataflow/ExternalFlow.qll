/**
 * INTERNAL use only. This is an experimental API subject to change without notice.
 *
 * Provides classes and predicates for dealing with flow models specified in CSV format.
 *
 * The CSV specification has the following columns:
 * - Sources:
 *   `namespace; type; subtypes; name; signature; ext; output; kind`
 * - Sinks:
 *   `namespace; type; subtypes; name; signature; ext; input; kind`
 * - Summaries:
 *   `namespace; type; subtypes; name; signature; ext; input; output; kind`
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
 */

import java
private import semmle.code.java.dataflow.DataFlow::DataFlow
private import internal.DataFlowPrivate
private import internal.FlowSummaryImpl::Private::External
private import internal.FlowSummaryImplSpecific
private import FlowSummary

/**
 * A module importing the frameworks that provide external flow data,
 * ensuring that they are visible to the taint tracking / data flow library.
 */
private module Frameworks {
  private import internal.ContainerFlow
  private import semmle.code.java.frameworks.android.Android
  private import semmle.code.java.frameworks.android.Intent
  private import semmle.code.java.frameworks.android.SQLite
  private import semmle.code.java.frameworks.android.XssSinks
  private import semmle.code.java.frameworks.ApacheHttp
  private import semmle.code.java.frameworks.apache.Collections
  private import semmle.code.java.frameworks.apache.Lang
  private import semmle.code.java.frameworks.Flexjson
  private import semmle.code.java.frameworks.guava.Guava
  private import semmle.code.java.frameworks.jackson.JacksonSerializability
  private import semmle.code.java.frameworks.javaee.jsf.JSFRenderer
  private import semmle.code.java.frameworks.JavaxJson
  private import semmle.code.java.frameworks.JaxWS
  private import semmle.code.java.frameworks.JoddJson
  private import semmle.code.java.frameworks.JsonJava
  private import semmle.code.java.frameworks.Objects
  private import semmle.code.java.frameworks.Optional
  private import semmle.code.java.frameworks.Stream
  private import semmle.code.java.frameworks.Strings
  private import semmle.code.java.frameworks.ratpack.Ratpack
  private import semmle.code.java.frameworks.ratpack.RatpackExec
  private import semmle.code.java.frameworks.spring.SpringCache
  private import semmle.code.java.frameworks.spring.SpringHttp
  private import semmle.code.java.frameworks.spring.SpringUtil
  private import semmle.code.java.frameworks.spring.SpringUi
  private import semmle.code.java.frameworks.spring.SpringValidation
  private import semmle.code.java.frameworks.spring.SpringWebClient
  private import semmle.code.java.frameworks.spring.SpringBeans
  private import semmle.code.java.frameworks.spring.SpringWebMultipart
  private import semmle.code.java.frameworks.spring.SpringWebUtil
  private import semmle.code.java.security.ResponseSplitting
  private import semmle.code.java.security.InformationLeak
  private import semmle.code.java.security.GroovyInjection
  private import semmle.code.java.security.JexlInjectionSinkModels
  private import semmle.code.java.security.JndiInjection
  private import semmle.code.java.security.LdapInjection
  private import semmle.code.java.security.MvelInjection
  private import semmle.code.java.security.OgnlInjection
  private import semmle.code.java.security.XPath
  private import semmle.code.java.security.XsltInjection
  private import semmle.code.java.frameworks.Jdbc
  private import semmle.code.java.frameworks.SpringJdbc
  private import semmle.code.java.frameworks.MyBatis
  private import semmle.code.java.frameworks.Hibernate
  private import semmle.code.java.frameworks.jOOQ
  private import semmle.code.java.frameworks.spring.SpringHttp
}

private predicate sourceModelCsv(string row) {
  row =
    [
      // org.springframework.security.web.savedrequest.SavedRequest
      "org.springframework.security.web.savedrequest;SavedRequest;true;getRedirectUrl;;;ReturnValue;remote",
      "org.springframework.security.web.savedrequest;SavedRequest;true;getCookies;;;ReturnValue;remote",
      "org.springframework.security.web.savedrequest;SavedRequest;true;getHeaderValues;;;ReturnValue;remote",
      "org.springframework.security.web.savedrequest;SavedRequest;true;getHeaderNames;;;ReturnValue;remote",
      "org.springframework.security.web.savedrequest;SavedRequest;true;getParameterValues;;;ReturnValue;remote",
      "org.springframework.security.web.savedrequest;SavedRequest;true;getParameterMap;;;ReturnValue;remote",
      // ServletRequestGetParameterMethod
      "javax.servlet;ServletRequest;false;getParameter;(String);;ReturnValue;remote",
      "javax.servlet;ServletRequest;false;getParameterValues;(String);;ReturnValue;remote",
      "javax.servlet.http;HttpServletRequest;false;getParameter;(String);;ReturnValue;remote",
      "javax.servlet.http;HttpServletRequest;false;getParameterValues;(String);;ReturnValue;remote",
      // ServletRequestGetParameterMapMethod
      "javax.servlet;ServletRequest;false;getParameterMap;();;ReturnValue;remote",
      "javax.servlet.http;HttpServletRequest;false;getParameterMap;();;ReturnValue;remote",
      // ServletRequestGetParameterNamesMethod
      "javax.servlet;ServletRequest;false;getParameterNames;();;ReturnValue;remote",
      "javax.servlet.http;HttpServletRequest;false;getParameterNames;();;ReturnValue;remote",
      // HttpServletRequestGetQueryStringMethod
      "javax.servlet.http;HttpServletRequest;false;getQueryString;();;ReturnValue;remote",
      //
      // URLConnectionGetInputStreamMethod
      "java.net;URLConnection;false;getInputStream;();;ReturnValue;remote",
      // SocketGetInputStreamMethod
      "java.net;Socket;false;getInputStream;();;ReturnValue;remote",
      // BeanValidationSource
      "javax.validation;ConstraintValidator;true;isValid;;;Parameter[0];remote",
      // SpringMultipartRequestSource
      "org.springframework.web.multipart;MultipartRequest;true;getFile;(String);;ReturnValue;remote",
      "org.springframework.web.multipart;MultipartRequest;true;getFileMap;();;ReturnValue;remote",
      "org.springframework.web.multipart;MultipartRequest;true;getFileNames;();;ReturnValue;remote",
      "org.springframework.web.multipart;MultipartRequest;true;getFiles;(String);;ReturnValue;remote",
      "org.springframework.web.multipart;MultipartRequest;true;getMultiFileMap;();;ReturnValue;remote",
      "org.springframework.web.multipart;MultipartRequest;true;getMultipartContentType;(String);;ReturnValue;remote",
      // SpringMultipartFileSource
      "org.springframework.web.multipart;MultipartFile;true;getBytes;();;ReturnValue;remote",
      "org.springframework.web.multipart;MultipartFile;true;getContentType;();;ReturnValue;remote",
      "org.springframework.web.multipart;MultipartFile;true;getInputStream;();;ReturnValue;remote",
      "org.springframework.web.multipart;MultipartFile;true;getName;();;ReturnValue;remote",
      "org.springframework.web.multipart;MultipartFile;true;getOriginalFilename;();;ReturnValue;remote",
      "org.springframework.web.multipart;MultipartFile;true;getResource;();;ReturnValue;remote",
      // HttpServletRequest.get*
      "javax.servlet.http;HttpServletRequest;false;getHeader;(String);;ReturnValue;remote",
      "javax.servlet.http;HttpServletRequest;false;getHeaders;(String);;ReturnValue;remote",
      "javax.servlet.http;HttpServletRequest;false;getHeaderNames;();;ReturnValue;remote",
      "javax.servlet.http;HttpServletRequest;false;getPathInfo;();;ReturnValue;remote",
      "javax.servlet.http;HttpServletRequest;false;getRequestURI;();;ReturnValue;remote",
      "javax.servlet.http;HttpServletRequest;false;getRequestURL;();;ReturnValue;remote",
      "javax.servlet.http;HttpServletRequest;false;getRemoteUser;();;ReturnValue;remote",
      // SpringWebRequestGetMethod
      "org.springframework.web.context.request;WebRequest;false;getDescription;;;ReturnValue;remote",
      "org.springframework.web.context.request;WebRequest;false;getHeader;;;ReturnValue;remote",
      "org.springframework.web.context.request;WebRequest;false;getHeaderNames;;;ReturnValue;remote",
      "org.springframework.web.context.request;WebRequest;false;getHeaderValues;;;ReturnValue;remote",
      "org.springframework.web.context.request;WebRequest;false;getParameter;;;ReturnValue;remote",
      "org.springframework.web.context.request;WebRequest;false;getParameterMap;;;ReturnValue;remote",
      "org.springframework.web.context.request;WebRequest;false;getParameterNames;;;ReturnValue;remote",
      "org.springframework.web.context.request;WebRequest;false;getParameterValues;;;ReturnValue;remote",
      // TODO consider org.springframework.web.context.request.WebRequest.getRemoteUser
      // ServletRequestGetBodyMethod
      "javax.servlet;ServletRequest;false;getInputStream;();;ReturnValue;remote",
      "javax.servlet;ServletRequest;false;getReader;();;ReturnValue;remote",
      // CookieGet*
      "javax.servlet.http;Cookie;false;getValue;();;ReturnValue;remote",
      "javax.servlet.http;Cookie;false;getName;();;ReturnValue;remote",
      "javax.servlet.http;Cookie;false;getComment;();;ReturnValue;remote",
      // ApacheHttp*
      "org.apache.http;HttpMessage;false;getParams;();;ReturnValue;remote",
      "org.apache.http;HttpEntity;false;getContent;();;ReturnValue;remote",
      // In the setting of Android we assume that XML has been transmitted over
      // the network, so may be tainted.
      // XmlPullGetMethod
      "org.xmlpull.v1;XmlPullParser;false;getName;();;ReturnValue;remote",
      "org.xmlpull.v1;XmlPullParser;false;getNamespace;();;ReturnValue;remote",
      "org.xmlpull.v1;XmlPullParser;false;getText;();;ReturnValue;remote",
      // XmlAttrSetGetMethod
      "android.util;AttributeSet;false;getAttributeBooleanValue;;;ReturnValue;remote",
      "android.util;AttributeSet;false;getAttributeCount;;;ReturnValue;remote",
      "android.util;AttributeSet;false;getAttributeFloatValue;;;ReturnValue;remote",
      "android.util;AttributeSet;false;getAttributeIntValue;;;ReturnValue;remote",
      "android.util;AttributeSet;false;getAttributeListValue;;;ReturnValue;remote",
      "android.util;AttributeSet;false;getAttributeName;;;ReturnValue;remote",
      "android.util;AttributeSet;false;getAttributeNameResource;;;ReturnValue;remote",
      "android.util;AttributeSet;false;getAttributeNamespace;;;ReturnValue;remote",
      "android.util;AttributeSet;false;getAttributeResourceValue;;;ReturnValue;remote",
      "android.util;AttributeSet;false;getAttributeUnsignedIntValue;;;ReturnValue;remote",
      "android.util;AttributeSet;false;getAttributeValue;;;ReturnValue;remote",
      "android.util;AttributeSet;false;getClassAttribute;;;ReturnValue;remote",
      "android.util;AttributeSet;false;getIdAttribute;;;ReturnValue;remote",
      "android.util;AttributeSet;false;getIdAttributeResourceValue;;;ReturnValue;remote",
      "android.util;AttributeSet;false;getPositionDescription;;;ReturnValue;remote",
      "android.util;AttributeSet;false;getStyleAttribute;;;ReturnValue;remote",
      // The current URL in a browser may be untrusted or uncontrolled.
      // WebViewGetUrlMethod
      "android.webkit;WebView;false;getUrl;();;ReturnValue;remote",
      "android.webkit;WebView;false;getOriginalUrl;();;ReturnValue;remote",
      // SpringRestTemplateResponseEntityMethod
      "org.springframework.web.client;RestTemplate;false;exchange;;;ReturnValue;remote",
      "org.springframework.web.client;RestTemplate;false;getForEntity;;;ReturnValue;remote",
      "org.springframework.web.client;RestTemplate;false;postForEntity;;;ReturnValue;remote",
      // WebSocketMessageParameterSource
      "java.net.http;WebSocket$Listener;true;onText;(WebSocket,CharSequence,boolean);;Parameter[1];remote",
      // PlayRequestGetMethod
      "play.mvc;Http$RequestHeader;false;queryString;;;ReturnValue;remote",
      "play.mvc;Http$RequestHeader;false;getQueryString;;;ReturnValue;remote",
      "play.mvc;Http$RequestHeader;false;header;;;ReturnValue;remote",
      "play.mvc;Http$RequestHeader;false;getHeader;;;ReturnValue;remote"
    ]
}

private predicate sinkModelCsv(string row) {
  row =
    [
      // Open URL
      "java.net;URL;false;openConnection;;;Argument[-1];open-url",
      "java.net;URL;false;openStream;;;Argument[-1];open-url",
      "java.net.http;HttpRequest;false;newBuilder;;;Argument[0];open-url",
      "java.net.http;HttpRequest$Builder;false;uri;;;Argument[0];open-url",
      "java.net;URLClassLoader;false;URLClassLoader;(URL[]);;Argument[0];open-url",
      "java.net;URLClassLoader;false;URLClassLoader;(URL[],ClassLoader);;Argument[0];open-url",
      "java.net;URLClassLoader;false;URLClassLoader;(URL[],ClassLoader,URLStreamHandlerFactory);;Argument[0];open-url",
      "java.net;URLClassLoader;false;URLClassLoader;(String,URL[],ClassLoader);;Argument[1];open-url",
      "java.net;URLClassLoader;false;URLClassLoader;(String,URL[],ClassLoader,URLStreamHandlerFactory);;Argument[1];open-url",
      "java.net;URLClassLoader;false;newInstance;;;Argument[0];open-url",
      // Create file
      "java.io;FileOutputStream;false;FileOutputStream;;;Argument[0];create-file",
      "java.io;RandomAccessFile;false;RandomAccessFile;;;Argument[0];create-file",
      "java.io;FileWriter;false;FileWriter;;;Argument[0];create-file",
      "java.nio.file;Files;false;move;;;Argument[1];create-file",
      "java.nio.file;Files;false;copy;;;Argument[1];create-file",
      "java.nio.file;Files;false;newOutputStream;;;Argument[0];create-file",
      "java.nio.file;Files;false;newBufferedReader;;;Argument[0];create-file",
      "java.nio.file;Files;false;createDirectory;;;Argument[0];create-file",
      "java.nio.file;Files;false;createFile;;;Argument[0];create-file",
      "java.nio.file;Files;false;createLink;;;Argument[0];create-file",
      "java.nio.file;Files;false;createSymbolicLink;;;Argument[0];create-file",
      "java.nio.file;Files;false;createTempDirectory;;;Argument[0];create-file",
      "java.nio.file;Files;false;createTempFile;;;Argument[0];create-file",
      // Bean validation
      "javax.validation;ConstraintValidatorContext;true;buildConstraintViolationWithTemplate;;;Argument[0];bean-validation",
      // Set hostname
      "javax.net.ssl;HttpsURLConnection;true;setDefaultHostnameVerifier;;;Argument[0];set-hostname-verifier",
      "javax.net.ssl;HttpsURLConnection;true;setHostnameVerifier;;;Argument[0];set-hostname-verifier"
    ]
}

private predicate summaryModelCsv(string row) {
  row =
    [
      // qualifier to arg
      "java.io;InputStream;true;read;(byte[]);;Argument[-1];Argument[0];taint",
      "java.io;InputStream;true;read;(byte[],int,int);;Argument[-1];Argument[0];taint",
      "java.io;InputStream;true;readNBytes;(byte[],int,int);;Argument[-1];Argument[0];taint",
      "java.io;InputStream;true;transferTo;(OutputStream);;Argument[-1];Argument[0];taint",
      "java.io;ByteArrayOutputStream;false;writeTo;;;Argument[-1];Argument[0];taint",
      "java.io;Reader;true;read;;;Argument[-1];Argument[0];taint",
      // qualifier to return
      "java.io;ByteArrayOutputStream;false;toByteArray;;;Argument[-1];ReturnValue;taint",
      "java.io;ByteArrayOutputStream;false;toString;;;Argument[-1];ReturnValue;taint",
      "java.io;InputStream;true;readAllBytes;;;Argument[-1];ReturnValue;taint",
      "java.io;InputStream;true;readNBytes;(int);;Argument[-1];ReturnValue;taint",
      "java.util;StringTokenizer;false;nextElement;();;Argument[-1];ReturnValue;taint",
      "java.util;StringTokenizer;false;nextToken;;;Argument[-1];ReturnValue;taint",
      "javax.xml.transform.sax;SAXSource;false;getInputSource;;;Argument[-1];ReturnValue;taint",
      "javax.xml.transform.stream;StreamSource;false;getInputStream;;;Argument[-1];ReturnValue;taint",
      "java.nio;ByteBuffer;false;get;;;Argument[-1];ReturnValue;taint",
      "java.net;URI;false;toURL;;;Argument[-1];ReturnValue;taint",
      "java.net;URI;false;toString;;;Argument[-1];ReturnValue;taint",
      "java.net;URI;false;toASCIIString;;;Argument[-1];ReturnValue;taint",
      "java.io;File;false;toURI;;;Argument[-1];ReturnValue;taint",
      "java.io;File;false;toPath;;;Argument[-1];ReturnValue;taint",
      "java.nio;ByteBuffer;false;array;();;Argument[-1];ReturnValue;taint",
      "java.nio.file;Path;false;toFile;;;Argument[-1];ReturnValue;taint",
      "java.io;BufferedReader;true;readLine;;;Argument[-1];ReturnValue;taint",
      "java.io;Reader;true;read;();;Argument[-1];ReturnValue;taint",
      // arg to return
      "java.nio;ByteBuffer;false;wrap;(byte[]);;Argument[0];ReturnValue;taint",
      "java.util;Base64$Encoder;false;encode;(byte[]);;Argument[0];ReturnValue;taint",
      "java.util;Base64$Encoder;false;encode;(ByteBuffer);;Argument[0];ReturnValue;taint",
      "java.util;Base64$Encoder;false;encodeToString;(byte[]);;Argument[0];ReturnValue;taint",
      "java.util;Base64$Encoder;false;wrap;(OutputStream);;Argument[0];ReturnValue;taint",
      "java.util;Base64$Decoder;false;decode;(byte[]);;Argument[0];ReturnValue;taint",
      "java.util;Base64$Decoder;false;decode;(ByteBuffer);;Argument[0];ReturnValue;taint",
      "java.util;Base64$Decoder;false;decode;(String);;Argument[0];ReturnValue;taint",
      "java.util;Base64$Decoder;false;wrap;(InputStream);;Argument[0];ReturnValue;taint",
      "cn.hutool.core.codec;Base64;true;decode;;;Argument[0];ReturnValue;taint",
      "org.apache.shiro.codec;Base64;false;decode;(String);;Argument[0];ReturnValue;taint",
      "org.apache.commons.codec;Encoder;true;encode;(Object);;Argument[0];ReturnValue;taint",
      "org.apache.commons.codec;Decoder;true;decode;(Object);;Argument[0];ReturnValue;taint",
      "org.apache.commons.codec;BinaryEncoder;true;encode;(byte[]);;Argument[0];ReturnValue;taint",
      "org.apache.commons.codec;BinaryDecoder;true;decode;(byte[]);;Argument[0];ReturnValue;taint",
      "org.apache.commons.codec;StringEncoder;true;encode;(String);;Argument[0];ReturnValue;taint",
      "org.apache.commons.codec;StringDecoder;true;decode;(String);;Argument[0];ReturnValue;taint",
      "org.apache.commons.io;IOUtils;false;buffer;;;Argument[0];ReturnValue;taint",
      "org.apache.commons.io;IOUtils;false;readLines;;;Argument[0];ReturnValue;taint",
      "org.apache.commons.io;IOUtils;false;readFully;(InputStream,int);;Argument[0];ReturnValue;taint",
      "org.apache.commons.io;IOUtils;false;toBufferedInputStream;;;Argument[0];ReturnValue;taint",
      "org.apache.commons.io;IOUtils;false;toBufferedReader;;;Argument[0];ReturnValue;taint",
      "org.apache.commons.io;IOUtils;false;toByteArray;;;Argument[0];ReturnValue;taint",
      "org.apache.commons.io;IOUtils;false;toCharArray;;;Argument[0];ReturnValue;taint",
      "org.apache.commons.io;IOUtils;false;toInputStream;;;Argument[0];ReturnValue;taint",
      "org.apache.commons.io;IOUtils;false;toString;;;Argument[0];ReturnValue;taint",
      "java.net;URLDecoder;false;decode;;;Argument[0];ReturnValue;taint",
      "java.net;URI;false;create;;;Argument[0];ReturnValue;taint",
      "javax.xml.transform.sax;SAXSource;false;sourceToInputSource;;;Argument[0];ReturnValue;taint",
      // arg to arg
      "java.lang;System;false;arraycopy;;;Argument[0];Argument[2];taint",
      "org.apache.commons.io;IOUtils;false;copy;;;Argument[0];Argument[1];taint",
      "org.apache.commons.io;IOUtils;false;copyLarge;;;Argument[0];Argument[1];taint",
      "org.apache.commons.io;IOUtils;false;read;;;Argument[0];Argument[1];taint",
      "org.apache.commons.io;IOUtils;false;readFully;(InputStream,byte[]);;Argument[0];Argument[1];taint",
      "org.apache.commons.io;IOUtils;false;readFully;(InputStream,byte[],int,int);;Argument[0];Argument[1];taint",
      "org.apache.commons.io;IOUtils;false;readFully;(InputStream,ByteBuffer);;Argument[0];Argument[1];taint",
      "org.apache.commons.io;IOUtils;false;readFully;(ReadableByteChannel,ByteBuffer);;Argument[0];Argument[1];taint",
      "org.apache.commons.io;IOUtils;false;readFully;(Reader,char[]);;Argument[0];Argument[1];taint",
      "org.apache.commons.io;IOUtils;false;readFully;(Reader,char[],int,int);;Argument[0];Argument[1];taint",
      "org.apache.commons.io;IOUtils;false;write;;;Argument[0];Argument[1];taint",
      "org.apache.commons.io;IOUtils;false;writeChunked;;;Argument[0];Argument[1];taint",
      "org.apache.commons.io;IOUtils;false;writeLines;;;Argument[0];Argument[2];taint",
      "org.apache.commons.io;IOUtils;false;writeLines;;;Argument[1];Argument[2];taint",
      // constructor flow
      "java.io;File;false;File;;;Argument[0];Argument[-1];taint",
      "java.io;File;false;File;;;Argument[1];Argument[-1];taint",
      "java.net;URI;false;URI;(String);;Argument[0];Argument[-1];taint",
      "java.net;URL;false;URL;(String);;Argument[0];Argument[-1];taint",
      "javax.xml.transform.stream;StreamSource;false;StreamSource;;;Argument[0];Argument[-1];taint",
      "javax.xml.transform.sax;SAXSource;false;SAXSource;(InputSource);;Argument[0];Argument[-1];taint",
      "javax.xml.transform.sax;SAXSource;false;SAXSource;(XMLReader,InputSource);;Argument[1];Argument[-1];taint",
      "org.xml.sax;InputSource;false;InputSource;;;Argument[0];Argument[-1];taint",
      "javax.servlet.http;Cookie;false;Cookie;;;Argument[0];Argument[-1];taint",
      "javax.servlet.http;Cookie;false;Cookie;;;Argument[1];Argument[-1];taint",
      "java.util.zip;ZipInputStream;false;ZipInputStream;;;Argument[0];Argument[-1];taint",
      "java.util.zip;GZIPInputStream;false;GZIPInputStream;;;Argument[0];Argument[-1];taint",
      "java.util;StringTokenizer;false;StringTokenizer;;;Argument[0];Argument[-1];taint",
      "java.beans;XMLDecoder;false;XMLDecoder;;;Argument[0];Argument[-1];taint",
      "com.esotericsoftware.kryo.io;Input;false;Input;;;Argument[0];Argument[-1];taint",
      "com.esotericsoftware.kryo5.io;Input;false;Input;;;Argument[0];Argument[-1];taint",
      "java.io;BufferedInputStream;false;BufferedInputStream;;;Argument[0];Argument[-1];taint",
      "java.io;DataInputStream;false;DataInputStream;;;Argument[0];Argument[-1];taint",
      "java.io;ByteArrayInputStream;false;ByteArrayInputStream;;;Argument[0];Argument[-1];taint",
      "java.io;ObjectInputStream;false;ObjectInputStream;;;Argument[0];Argument[-1];taint",
      "java.io;StringReader;false;StringReader;;;Argument[0];Argument[-1];taint",
      "java.io;CharArrayReader;false;CharArrayReader;;;Argument[0];Argument[-1];taint",
      "java.io;BufferedReader;false;BufferedReader;;;Argument[0];Argument[-1];taint",
      "java.io;InputStreamReader;false;InputStreamReader;;;Argument[0];Argument[-1];taint"
    ]
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

private string sourceModelRow() {
  sourceModelCsv(result) or
  any(SourceModelCsv s).row(result)
}

private string sinkModelRow() {
  sinkModelCsv(result) or
  any(SinkModelCsv s).row(result)
}

private string summaryModelRow() {
  summaryModelCsv(result) or
  any(SummaryModelCsv s).row(result)
}

/**
 * Holds if a source model exists for the given parameters. The result is the CSV row
 * representing the model.
 */
string sourceModel(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string output, string kind
) {
  result = sourceModelRow() and
  result.splitAt(";", 0) = namespace and
  result.splitAt(";", 1) = type and
  result.splitAt(";", 2) = subtypes.toString() and
  subtypes = [true, false] and
  result.splitAt(";", 3) = name and
  result.splitAt(";", 4) = signature and
  result.splitAt(";", 5) = ext and
  result.splitAt(";", 6) = output and
  result.splitAt(";", 7) = kind
}

/**
 * Holds if a sink model exists for the given parameters. The result is the CSV row
 * representing the model.
 */
string sinkModel(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string input, string kind
) {
  result = sinkModelRow() and
  result.splitAt(";", 0) = namespace and
  result.splitAt(";", 1) = type and
  result.splitAt(";", 2) = subtypes.toString() and
  subtypes = [true, false] and
  result.splitAt(";", 3) = name and
  result.splitAt(";", 4) = signature and
  result.splitAt(";", 5) = ext and
  result.splitAt(";", 6) = input and
  result.splitAt(";", 7) = kind
}

/**
 * Holds if a summary model exists for the given parameters. The result is the CSV row
 * representing the model.
 */
string summaryModel(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string input, string output, string kind
) {
  result = summaryModelRow() and
  result.splitAt(";", 0) = namespace and
  result.splitAt(";", 1) = type and
  result.splitAt(";", 2) = subtypes.toString() and
  subtypes = [true, false] and
  result.splitAt(";", 3) = name and
  result.splitAt(";", 4) = signature and
  result.splitAt(";", 5) = ext and
  result.splitAt(";", 6) = input and
  result.splitAt(";", 7) = output and
  result.splitAt(";", 8) = kind
}

private predicate relevantPackage(string package) {
  exists(sourceModel(package, _, _, _, _, _, _, _)) or
  exists(sinkModel(package, _, _, _, _, _, _, _)) or
  exists(summaryModel(package, _, _, _, _, _, _, _, _))
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
        string ext, string output |
        canonicalPkgLink(package, subpkg) and
        exists(sourceModel(subpkg, type, subtypes, name, signature, ext, output, kind))
      )
    or
    part = "sink" and
    n =
      strictcount(string subpkg, string type, boolean subtypes, string name, string signature,
        string ext, string input |
        canonicalPkgLink(package, subpkg) and
        exists(sinkModel(subpkg, type, subtypes, name, signature, ext, input, kind))
      )
    or
    part = "summary" and
    n =
      strictcount(string subpkg, string type, boolean subtypes, string name, string signature,
        string ext, string input, string output |
        canonicalPkgLink(package, subpkg) and
        exists(summaryModel(subpkg, type, subtypes, name, signature, ext, input, output, kind))
      )
  )
}

/** Provides a query predicate to check the CSV data for validation errors. */
module CsvValidation {
  /** Holds if some row in a CSV-based flow model appears to contain typos. */
  query predicate invalidModelRow(string row, string msg) {
    exists(
      string namespace, string type, boolean subtypes, string name, string signature, string ext
    |
      row = sourceModel(namespace, type, subtypes, name, signature, ext, _, _)
      or
      row = sinkModel(namespace, type, subtypes, name, signature, ext, _, _)
      or
      row = summaryModel(namespace, type, subtypes, name, signature, ext, _, _, _)
    |
      not namespace.regexpMatch("[a-zA-Z0-9_\\.]+") and
      msg = "Dubious namespace \"" + namespace + "\""
      or
      not type.regexpMatch("[a-zA-Z0-9_\\$<>]+") and
      msg = "Dubious type \"" + type + "\""
      or
      not name.regexpMatch("[a-zA-Z0-9_]*") and
      msg = "Dubious name \"" + name + "\""
      or
      not signature.regexpMatch("|\\([a-zA-Z0-9_\\.\\$<>,\\[\\]]*\\)") and
      msg = "Dubious signature \"" + signature + "\"."
      or
      not ext.regexpMatch("|Annotated") and
      msg = "Unrecognized extra API graph element \"" + ext + "\""
      or
      ext = "Annotated" and
      (
        subtypes = true and
        msg = "subtypes does not work for Annotated"
        or
        "" != [name, signature] and
        msg = "Annotated does not support name or signature"
      )
      or
      ext = "" and
      name = "" and
      msg = "Must provide member name"
    )
    or
    exists(string pred, string input, string part |
      row = sinkModel(_, _, _, _, _, _, input, _) and pred = "sink"
      or
      row = summaryModel(_, _, _, _, _, _, input, _, _) and pred = "summary"
    |
      (
        invalidSpecComponent(input, part) and
        not part = "" and
        not (part = "Argument" and pred = "sink") and
        not parseArg(part, _)
        or
        part = specLast(input) and
        parseParam(part, _)
      ) and
      msg = "Unrecognized input specification \"" + part + "\""
    )
    or
    exists(string pred, string output, string part |
      row = sourceModel(_, _, _, _, _, _, output, _) and pred = "source"
      or
      row = summaryModel(_, _, _, _, _, _, _, output, _) and pred = "summary"
    |
      invalidSpecComponent(output, part) and
      not part = "" and
      not (part = ["Argument", "Parameter"] and pred = "source") and
      msg = "Unrecognized output specification \"" + part + "\""
    )
    or
    exists(
      string package, string typeName, boolean subtypes, string memberName, string signature,
      string input, string output, string kind, string otherRow, boolean otherSubtypes,
      string otherSignature, string otherInput, string otherOutput
    |
      row = sourceModelRow() and
      row = sourceModel(package, typeName, subtypes, memberName, signature, _, output, kind) and
      input = ""
      or
      row = sinkModelRow() and
      row = sinkModel(package, typeName, subtypes, memberName, signature, _, input, kind) and
      output = ""
      or
      row = summaryModelRow() and
      row = summaryModel(package, typeName, subtypes, memberName, signature, _, input, output, kind)
    |
      (
        otherRow = sourceModelRow() and
        otherRow =
          sourceModel(package, typeName, otherSubtypes, memberName, otherSignature, _, otherOutput,
            kind) and
        otherInput = ""
        or
        otherRow = sinkModelRow() and
        otherRow =
          sinkModel(package, typeName, otherSubtypes, memberName, otherSignature, _, otherInput,
            kind) and
        otherOutput = ""
        or
        otherRow = summaryModelRow() and
        otherRow =
          summaryModel(package, typeName, otherSubtypes, memberName, otherSignature, _, otherInput,
            otherOutput, kind)
      ) and
      otherRow != row and
      (
        // Duplicate row with same input and output
        (
          input = otherInput and
          output = otherOutput
        ) and
        (
          signature = "" or
          signature = otherSignature
        )
        or
        // subtypes mismatch and row considering subtypes allows any signature
        subtypes = true and
        signature = "" and
        otherSubtypes = false
      ) and
      msg = "Duplicates row: " + otherRow
    )
    or
    (
      row = sourceModelRow() and
      not row = sourceModel(_, _, _, _, _, _, _, _)
      or
      row = sinkModelRow() and
      not row = sinkModel(_, _, _, _, _, _, _, _)
      or
      row = summaryModelRow() and
      not row = summaryModel(_, _, _, _, _, _, _, _, _)
    ) and
    msg = "Malformed row"
    or
    exists(string pred, int expect |
      row = sourceModelRow() and expect = 8 and pred = "source"
      or
      row = sinkModelRow() and expect = 8 and pred = "sink"
      or
      row = summaryModelRow() and expect = 9 and pred = "summary"
    |
      exists(int cols |
        cols = 1 + max(int n | exists(row.splitAt(";", n))) and
        cols != expect and
        msg =
          "Wrong number of columns in " + pred + " model row, expected " + expect + ", got " + cols +
            "."
      )
      or
      exists(string b |
        b = row.splitAt(";", 2) and
        not b = ["true", "false"] and
        msg = "Invalid boolean \"" + b + "\" in " + pred + " model."
      )
    )
  }
}

/**
 * Provides a query predicate to verify that the CSV data is reasonable. The query should be run against
 * one of the projects for which the CSV data is written.
 */
module CsvDataValidation {
  bindingset[memberName, signature]
  private Member getMatchingMember(RefType declaringType, string memberName, string signature) {
    (
      result instanceof Field or
      result instanceof Callable
    ) and
    result.fromSource() and
    result.getDeclaringType() = declaringType and
    result.hasName(memberName) and
    if signature = "" then any() else paramsString(result) = signature
  }

  bindingset[memberName, signature]
  private boolean hasOverridableMember(RefType declaringType, string memberName, string signature) {
    exists(Member m | m = getMatchingMember(declaringType, memberName, signature) |
      if
        m.isFinal() or
        m.isStatic() or
        m instanceof Constructor or
        m instanceof Field
      then result = false
      else result = true
    )
  }

  // Workaround for https://github.com/github/codeql/issues/5556
  private CompilationUnit getACompilationUnit(RefType t) {
    exists(CompilationUnit c | c = t.getCompilationUnit() |
      c.getPackage() = result.getPackage() and
      c.getName() = result.getName()
    )
  }

  private predicate isPubliclyVisible(RefType t) {
    (t.isProtected() or t.isPublic()) and
    (
      if t instanceof TopLevelType
      then
        // If source code is modular, package must be exported
        if exists(getACompilationUnit(t).getModule())
        then
          exists(Module m, ExportsDirective exportsDirective |
            m = getACompilationUnit(t).getModule()
          |
            exportsDirective.getExportedPackage().getName() = t.getPackage().getName() and
            // Require that export is to all modules
            not exportsDirective.isQualified()
          )
        else any()
      else isPubliclyVisible(t.getEnclosingType())
    ) and
    not (
      t instanceof LocalClassOrInterface or
      t instanceof AnonymousClass
    )
  }

  // Severity: 0 (issue), 1 (warning), 2 (info)
  query predicate checkRowData(int severity, string csvRow, string msg) {
    exists(
      boolean considerSubtypes, string package, string typeName, string memberName,
      string signature, string ext
    |
      csvRow = sourceModelRow() and
      csvRow = sourceModel(package, typeName, considerSubtypes, memberName, signature, ext, _, _)
      or
      csvRow = sinkModelRow() and
      csvRow = sinkModel(package, typeName, considerSubtypes, memberName, signature, ext, _, _)
      or
      csvRow = summaryModelRow() and
      csvRow =
        summaryModel(package, typeName, considerSubtypes, memberName, signature, ext, _, _, _)
    |
      // Only consider if package is part of database
      exists(RefType o |
        o.fromSource() and
        o.hasQualifiedName(package, _) and
        // Ignore AnonymousClass; it has same package name as subclassed type and is from source
        not o instanceof AnonymousClass
      ) and
      not exists(RefType t |
        t.fromSource() and
        t.hasQualifiedName(package, typeName)
      ) and
      msg = "Type '" + package + "." + typeName + "' does not exist" and
      severity = 0
      or
      exists(RefType t, string qualifiedTypeName |
        t.fromSource() and
        t.hasQualifiedName(package, typeName) and
        qualifiedTypeName = package + "." + typeName
      |
        memberName.length() > 0 and
        not exists(getMatchingMember(t, memberName, signature)) and
        msg = "Type " + qualifiedTypeName + " has no member called '" + memberName + "'" and
        severity = 0
        or
        ext = "Annotated" and
        not t instanceof AnnotationType and
        msg = "Type " + qualifiedTypeName + " is not an annotation type" and
        severity = 0
        or
        considerSubtypes = true and
        (
          t.isFinal()
          or
          forex(Constructor c | c.getDeclaringType() = t | t.isPrivate()) and
          not exists(RefType sub |
            sub.fromSource() and
            sub.getASourceSupertype+() = t
          )
        ) and
        msg = "Type " + qualifiedTypeName + " cannot have subtypes" and
        severity = 1
        or
        considerSubtypes = true and
        hasOverridableMember(t, memberName, signature) = false and
        msg = "Member '" + memberName + "' cannot be overridden" and
        severity = 1
        or
        considerSubtypes = true and
        (
          t instanceof Class and
          not exists(Constructor c |
            c.getDeclaringType() = t and
            (c.isProtected() or c.isPublic())
          )
          or
          not (t.isProtected() or t.isPublic())
        ) and
        not exists(RefType sub |
          sub.fromSource() and
          sub.getASourceSupertype+() = t and
          isPubliclyVisible(sub)
        ) and
        msg = "Type " + qualifiedTypeName + " does not have public subtypes" and
        severity = 2
        or
        considerSubtypes = false and
        (
          t instanceof Interface and
          isPubliclyVisible(t) and
          msg = "Type " + qualifiedTypeName + " likely has subtypes" and
          severity = 1
          or
          t.isAbstract() and
          isPubliclyVisible(t) and
          exists(Constructor c |
            c.getDeclaringType() = t and
            (c.isProtected() or c.isPublic())
          ) and
          msg = "Type " + qualifiedTypeName + " might have subtypes" and
          severity = 2
          or
          // Or exists (probably) publicly visible subtype
          exists(RefType sub |
            sub.fromSource() and
            sub.getASourceSupertype+() = t and
            isPubliclyVisible(sub) and
            (
              exists(Method m, Method overriding |
                m = getMatchingMember(t, memberName, signature) and
                overriding.getDeclaringType() = sub and
                overriding.overrides+(m)
              ) and
              msg = "Method '" + memberName + "' is overridden by subtype " + sub.getQualifiedName() and
              severity = 1
              or
              msg = "Type " + qualifiedTypeName + " has subtype " + sub.getQualifiedName() and
              severity = 1
            )
          )
        ) and
        // Only report row when member can actually be overridden
        (
          hasOverridableMember(t, memberName, signature) = true or
          memberName = ""
        )
        or
        // Modelling private types probably does not add much value because they won't be used externally
        considerSubtypes = false and
        not isPubliclyVisible(t) and
        msg = "Type " + qualifiedTypeName + " is not publicly visible" and
        severity = 1
        or
        // Modelling private members probably does not add much value because they won't be used externally
        // Note: Uses `forex` to ignore cases where multiple members match and only one is private
        forex(Member m | m = getMatchingMember(t, memberName, signature) |
          not (m.isProtected() or m.isPublic())
        ) and
        msg = "Member '" + memberName + "' is not publicly visible" and
        severity = 1
        or
        exists(Method m, Method overridden, RefType declaringType |
          m = getMatchingMember(t, memberName, signature)
        |
          m.overridesOrInstantiates+(overridden) and
          declaringType = overridden.getDeclaringType().getSourceDeclaration() and
          not declaringType instanceof TypeObject and
          msg =
            "Method '" + memberName + "' overrides method of type " +
              declaringType.getQualifiedName() + "; could model that instead" and
          severity = 2
        )
      )
    )
  }
}

pragma[nomagic]
private predicate elementSpec(
  string namespace, string type, boolean subtypes, string name, string signature, string ext
) {
  exists(sourceModel(namespace, type, subtypes, name, signature, ext, _, _)) or
  exists(sinkModel(namespace, type, subtypes, name, signature, ext, _, _)) or
  exists(summaryModel(namespace, type, subtypes, name, signature, ext, _, _, _))
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

/** Gets the source/sink/summary element corresponding to the supplied parameters. */
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

private predicate parseField(string c, FieldContent f) {
  specSplit(_, c, _) and
  exists(string fieldRegex, string package, string className, string fieldName |
    fieldRegex = "^Field\\[(.*)\\.([^.]+)\\.([^.]+)\\]$" and
    package = c.regexpCapture(fieldRegex, 1) and
    className = c.regexpCapture(fieldRegex, 2) and
    fieldName = c.regexpCapture(fieldRegex, 3) and
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

private predicate parseSynthField(string c, string f) {
  specSplit(_, c, _) and
  c.regexpCapture("SyntheticField\\[([.a-zA-Z0-9]+)\\]", 1) = f
}

/** Holds if the specification component parses as a `Content`. */
predicate parseContent(string component, Content content) {
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
