/*
 * Copyright (C) Lightbend Inc. <https://www.lightbend.com>
 */

package play.mvc;

import java.io.File;
import java.io.InputStream;
import java.util.Collections;
import java.util.Optional;
import akka.util.ByteString;
import com.fasterxml.jackson.core.JsonEncoding;
import com.fasterxml.jackson.databind.JsonNode;
import play.api.mvc.StatusHeader;
import play.mvc.Result;
import play.twirl.api.Content;

/* Most of these are stubbed not yes useful imports from scala */
//import play.api.mvc.Results$;
//import play.core.j.JavaHelpers;
//import play.http.HttpEntity;
//import scala.collection.JavaConverters;
//import scala.compat.java8.OptionConverters;

import static play.mvc.Http.HeaderNames.LOCATION;
import static play.mvc.Http.Status.*;

/** Common results. */
public class Results {

  private static final String UTF8 = "utf-8";

  // -- Constructor methods

  /** Generates a 501 NOT_IMPLEMENTED simple result. */
  //public static final Result TODO = status(NOT_IMPLEMENTED, views.html.defaultpages.todo.render());

  // -- Status

  /**
   * Generates a simple result.
   *
   * @param status the HTTP status for this result e.g. 200 (OK), 404 (NOT_FOUND)
   * @
   */
  public static StatusHeader status(int status) {

  }

  /**
   * Generates a simple result.
   *
   * @param status the HTTP status for this result e.g. 200 (OK), 404 (NOT_FOUND)
   * @param content the result's body content
   * @
   */
  public static Result status(int status, Content content) {

  }

  /**
   * Generates a simple result.
   *
   * @param status the HTTP status for this result e.g. 200 (OK), 404 (NOT_FOUND)
   * @param content the result's body content
   * @param charset the charset to encode the content with (e.g. "UTF-8")
   * @
   */
  public static Result status(int status, Content content, String charset) {

  }

  /**
   * Generates a simple result.
   *
   * @param status the HTTP status for this result e.g. 200 (OK), 404 (NOT_FOUND)
   * @param content the result's body content. It will be encoded as a UTF-8 string.
   * @
   */
  public static Result status(int status, String content) {

  }

  /**
   * Generates a simple result.
   *
   * @param status the HTTP status for this result e.g. 200 (OK), 404 (NOT_FOUND)
   * @param content the result's body content.
   * @param charset the charset in which to encode the content (e.g. "UTF-8")
   * @
   */
  public static Result status(int status, String content, String charset) {

  }

  /**
   * Generates a simple result with json content and UTF8 encoding.
   *
   * @param status the HTTP status for this result e.g. 200 (OK), 404 (NOT_FOUND)
   * @param content the result's body content as a play-json object
   * @
   */
  public static Result status(int status, JsonNode content) {

  }

  /**
   * Generates a simple result with json content.
   *
   * @param status the HTTP status for this result e.g. 200 (OK), 404 (NOT_FOUND)
   * @param content the result's body content, as a play-json object
   * @param charset the charset into which the json should be encoded
   * @
   * @deprecated As of 2.6.0, use status(int, JsonNode, JsonEncoding)
   */
  @Deprecated
  public static Result status(int status, JsonNode content, String charset) {

  }

  /**
   * Generates a simple result with json content.
   *
   * @param status the HTTP status for this result e.g. 200 (OK), 404 (NOT_FOUND)
   * @param content the result's body content, as a play-json object
   * @param encoding the encoding into which the json should be encoded
   * @
   */
  public static Result status(int status, JsonNode content, JsonEncoding encoding) {
  }

  /**
   * Generates a simple result with byte-array content.
   *
   * @param status the HTTP status for this result e.g. 200 (OK), 404 (NOT_FOUND)
   * @param content the result's body content, as a byte array
   * @
   */
  public static Result status(int status, byte[] content) {
  }

  /**
   * Generates a simple result.
   *
   * @param status the HTTP status for this result e.g. 200 (OK), 404 (NOT_FOUND)
   * @param content the result's body content
   * @
   */
  public static Result status(int status, ByteString content) {
  }

  /**
   * Generates a chunked result.
   *
   * @param status the HTTP status for this result e.g. 200 (OK), 404 (NOT_FOUND)
   * @param content the input stream containing data to chunk over
   * @
   */
  public static Result status(int status, InputStream content) {

  }

  /**
   * Generates a chunked result.
   *
   * @param status the HTTP status for this result e.g. 200 (OK), 404 (NOT_FOUND)
   * @param content the input stream containing data to chunk over
   * @param contentLength the length of the provided content in bytes.
   * @
   */
  public static Result status(int status, InputStream content, long contentLength) {

  }

  /**
   * Generates a result with file contents.
   *
   * @param status the HTTP status for this result e.g. 200 (OK), 404 (NOT_FOUND)
   * @param content the file to send
   * @
   */
  public static Result status(int status, File content) {

  }

  /**
   * Generates a result with file content.
   *
   * @param status the HTTP status for this result e.g. 200 (OK), 404 (NOT_FOUND)
   * @param content the file to send
   * @param inline <code>true</code> to have it sent with inline Content-Disposition.
   * @
   */
  public static Result status(int status, File content, boolean inline) {

  }

  /**
   * Generates a result.
   *
   * @param status the HTTP status for this result e.g. 200 (OK), 404 (NOT_FOUND)
   * @param content the file to send
   * @param fileName the name that the client should receive this file as
   * @
   */
  public static Result status(int status, File content, String fileName) {

  }

  /**
   * Generates a 204 No Content result.
   *
   * @
   */
  public static StatusHeader noContent() {

  }

  //////////////////////////////////////////////////////
  // EVERYTHING BELOW HERE IS GENERATED
  //
  // See https://github.com/jroper/play-source-generator
  //////////////////////////////////////////////////////

  /**
   * Generates a 200 OK result.
   *
   * @
   */
  public static StatusHeader ok() {

  }

  /**
   * Generates a 200 OK result.
   *
   * @param content the HTTP response body
   * @
   */
  public static Result ok(Content content) {

  }

  /**
   * Generates a 200 OK result.
   *
   * @param content the HTTP response body
   * @param charset the charset into which the content should be encoded (e.g. "UTF-8")
   * @
   */
  public static Result ok(Content content, String charset) {

  }

  /**
   * Generates a 200 OK result.
   *
   * @param content HTTP response body, encoded as a UTF-8 string
   * @
   */
  public static Result ok(String content) {}

  /**
   * Generates a 200 OK result.
   *
   * @param content the HTTP response body
   * @param charset the charset into which the content should be encoded (e.g. "UTF-8")
   * @
   */
  public static Result ok(String content, String charset) {

  }

  /**
   * Generates a 200 OK result.
   *
   * @param content the result's body content as a play-json object. It will be encoded as a UTF-8
   *     string.
   * @
   */
  public static Result ok(JsonNode content) {

  }

  /**
   * Generates a 200 OK result.
   *
   * @param content the result's body content as a play-json object
   * @param charset the charset into which the json should be encoded
   * @
   * @deprecated As of 2.6.0, use ok(JsonNode, JsonEncoding)
   */
  @Deprecated
  public static Result ok(JsonNode content, String charset) {

  }

  /**
   * Generates a 200 OK result.
   *
   * @param content the result's body content as a play-json object
   * @param encoding the encoding into which the json should be encoded
   * @
   */
  public static Result ok(JsonNode content, JsonEncoding encoding) {

  }

  /**
   * Generates a 200 OK result.
   *
   * @param content the result's body content
   * @
   */
  public static Result ok(byte[] content) {

  }

  /**
   * Generates a 200 OK result.
   *
   * @param content the input stream containing data to chunk over
   * @
   */
  public static Result ok(InputStream content) {

  }

  /**
   * Generates a 200 OK result.
   *
   * @param content the input stream containing data to chunk over
   * @param contentLength the length of the provided content in bytes.
   * @
   */
  public static Result ok(InputStream content, long contentLength) {

  }

  /**
   * Generates a 200 OK result.
   *
   * @param content The file to send.
   * @
   */
  public static Result ok(File content) {

  }

  /**
   * Generates a 200 OK result.
   *
   * @param content The file to send.
   * @param inline Whether the file should be sent inline, or as an attachment.
   * @
   */
  public static Result ok(File content, boolean inline) {

  }

  /**
   * Generates a 200 OK result.
   *
   * @param content The file to send.
   * @param filename The name to send the file as.
   * @
   */
  public static Result ok(File content, String filename) {

  }

  /**
   * Generates a 201 Created result.
   *
   * @
   */
  public static StatusHeader created() {

  }

  /**
   * Generates a 201 Created result.
   *
   * @param content the HTTP response body
   * @
   */
/*   public static Result created(Content content) {

  } */

  /**
   * Generates a 201 Created result.
   *
   * @param content the HTTP response body
   * @param charset the charset into which the content should be encoded (e.g. "UTF-8")
   * @
   */
  public static Result created(Content content, String charset) {

  }

  /**
   * Generates a 201 Created result.
   *
   * @param content HTTP response body, encoded as a UTF-8 string
   * @
   */
  public static Result created(String content) {

  }

  /**
   * Generates a 201 Created result.
   *
   * @param content the HTTP response body
   * @param charset the charset into which the content should be encoded (e.g. "UTF-8")
   * @
   */
  public static Result created(String content, String charset) {

  }

  /**
   * Generates a 201 Created result.
   *
   * @param content the result's body content as a play-json object. It will be encoded as a UTF-8
   *     string.
   * @
   */
  public static Result created(JsonNode content) {

  }

  /**
   * Generates a 201 Created result.
   *
   * @param content the result's body content as a play-json object
   * @param charset the charset into which the json should be encoded
   * @
   * @deprecated As of 2.6.0, use created(JsonNode, JsonEncoding)
   */
  @Deprecated
  public static Result created(JsonNode content, String charset) {

  }

  /**
   * Generates a 201 Created result.
   *
   * @param content the result's body content as a play-json object
   * @param encoding the encoding into which the json should be encoded
   * @
   */
  public static Result created(JsonNode content, JsonEncoding encoding) {

  }

  /**
   * Generates a 201 Created result.
   *
   * @param content the result's body content
   * @
   */
  public static Result created(byte[] content) {

  }

  /**
   * Generates a 201 Created result.
   *
   * @param content the input stream containing data to chunk over
   * @
   */
  public static Result created(InputStream content) {

  }

  /**
   * Generates a 201 Created result.
   *
   * @param content the input stream containing data to chunk over
   * @param contentLength the length of the provided content in bytes.
   * @
   */
  public static Result created(InputStream content, long contentLength) {

  }

  /**
   * Generates a 201 Created result.
   *
   * @param content The file to send.
   * @
   */
  public static Result created(File content) {

  }

  /**
   * Generates a 201 Created result.
   *
   * @param content The file to send.
   * @param inline Whether the file should be sent inline, or as an attachment.
   * @
   */
  public static Result created(File content, boolean inline) {

  }

  /**
   * Generates a 201 Created result.
   *
   * @param content The file to send.
   * @param filename The name to send the file as.
   * @
   */
  public static Result created(File content, String filename) {

  }

  /**
   * Generates a 400 Bad Request result.
   *
   * @
   */
  public static StatusHeader badRequest() {

  }

  /**
   * Generates a 400 Bad Request result.
   *
   * @param content the HTTP response body
   * @
   */
/*   public static Result badRequest(Content content) {

  } */

  /**
   * Generates a 400 Bad Request result.
   *
   * @param content the HTTP response body
   * @param charset the charset into which the content should be encoded (e.g. "UTF-8")
   * @
   */
  public static Result badRequest(Content content, String charset) {

  }

  /**
   * Generates a 400 Bad Request result.
   *
   * @param content HTTP response body, encoded as a UTF-8 string
   * @
   */
  public static Result badRequest(String content) {

  }

  /**
   * Generates a 400 Bad Request result.
   *
   * @param content the HTTP response body
   * @param charset the charset into which the content should be encoded (e.g. "UTF-8")
   * @
   */
  public static Result badRequest(String content, String charset) {

  }

  /**
   * Generates a 400 Bad Request result.
   *
   * @param content the result's body content as a play-json object. It will be encoded as a UTF-8
   *     string.
   * @
   */
  public static Result badRequest(JsonNode content) {

  }

  /**
   * Generates a 400 Bad Request result.
   *
   * @param content the result's body content as a play-json object
   * @param charset the charset into which the json should be encoded
   * @
   * @deprecated As of 2.6.0, use badRequest(JsonNode, JsonEncoding)
   */
  @Deprecated
  public static Result badRequest(JsonNode content, String charset) {

  }

  /**
   * Generates a 400 Bad Request result.
   *
   * @param content the result's body content as a play-json object
   * @param encoding the encoding into which the json should be encoded
   * @
   */
  public static Result badRequest(JsonNode content, JsonEncoding encoding) {

  }

  /**
   * Generates a 400 Bad Request result.
   *
   * @param content the result's body content
   * @
   */
  public static Result badRequest(byte[] content) {

  }

  /**
   * Generates a 400 Bad Request result.
   *
   * @param content the input stream containing data to chunk over
   * @
   */
  public static Result badRequest(InputStream content) {

  }

  /**
   * Generates a 400 Bad Request result.
   *
   * @param content the input stream containing data to chunk over
   * @param contentLength the length of the provided content in bytes.
   * @
   */
  public static Result badRequest(InputStream content, long contentLength) {

  }

  /**
   * Generates a 400 Bad Request result.
   *
   * @param content The file to send.
   * @
   */
  public static Result badRequest(File content) {

  }

  /**
   * Generates a 400 Bad Request result.
   *
   * @param content The file to send.
   * @param inline Whether the file should be sent inline, or as an attachment.
   * @
   */
  public static Result badRequest(File content, boolean inline) {

  }

  /**
   * Generates a 400 Bad Request result.
   *
   * @param content The file to send.
   * @param filename The name to send the file as.
   * @
   */
  public static Result badRequest(File content, String filename) {

  }

  /**
   * Generates a 401 Unauthorized result.
   *
   * @
   */
  public static StatusHeader unauthorized() {

  }

  /**
   * Generates a 401 Unauthorized result.
   *
   * @param content the HTTP response body
   * @
   */
/*   public static Result unauthorized(Content content) {

  } */

  /**
   * Generates a 401 Unauthorized result.
   *
   * @param content the HTTP response body
   * @param charset the charset into which the content should be encoded (e.g. "UTF-8")
   * @
   */
  public static Result unauthorized(Content content, String charset) {

  }

  /**
   * Generates a 401 Unauthorized result.
   *
   * @param content HTTP response body, encoded as a UTF-8 string
   * @
   */
  public static Result unauthorized(String content) {

  }

  /**
   * Generates a 401 Unauthorized result.
   *
   * @param content the HTTP response body
   * @param charset the charset into which the content should be encoded (e.g. "UTF-8")
   * @
   */
  public static Result unauthorized(String content, String charset) {

  }

  /**
   * Generates a 401 Unauthorized result.
   *
   * @param content the result's body content as a play-json object. It will be encoded as a UTF-8
   *     string.
   * @
   */
  public static Result unauthorized(JsonNode content) {

  }

  /**
   * Generates a 401 Unauthorized result.
   *
   * @param content the result's body content as a play-json object
   * @param charset the charset into which the json should be encoded
   * @
   * @deprecated As of 2.6.0, use {@link #unauthorized(JsonNode, JsonEncoding)} instead.
   */
  @Deprecated
  public static Result unauthorized(JsonNode content, String charset) {

  }

  /**
   * Generates a 401 Unauthorized result.
   *
   * @param content the result's body content as a play-json object
   * @param encoding the encoding into which the json should be encoded
   * @
   */
  public static Result unauthorized(JsonNode content, JsonEncoding encoding) {

  }

  /**
   * Generates a 401 Unauthorized result.
   *
   * @param content the result's body content
   * @
   */
  public static Result unauthorized(byte[] content) {

  }

  /**
   * Generates a 401 Unauthorized result.
   *
   * @param content the input stream containing data to chunk over
   * @
   */
  public static Result unauthorized(InputStream content) {

  }

  /**
   * Generates a 401 Unauthorized result.
   *
   * @param content the input stream containing data to chunk over
   * @param contentLength the length of the provided content in bytes.
   * @
   */
  public static Result unauthorized(InputStream content, long contentLength) {

  }

  /**
   * Generates a 401 Unauthorized result.
   *
   * @param content The file to send.
   * @
   */
  public static Result unauthorized(File content) {

  }

  /**
   * Generates a 401 Unauthorized result.
   *
   * @param content The file to send.
   * @param inline Whether the file should be sent inline, or as an attachment.
   * @
   */
  public static Result unauthorized(File content, boolean inline) {

  }

  /**
   * Generates a 401 Unauthorized result.
   *
   * @param content The file to send.
   * @param filename The name to send the file as.
   * @
   */
  public static Result unauthorized(File content, String filename) {

  }

  /**
   * Generates a 402 Payment Required result.
   *
   * @
   */
  public static StatusHeader paymentRequired() {

  }

  /**
   * Generates a 402 Payment Required result.
   *
   * @param content the HTTP response body
   * @
   */
  public static Result paymentRequired(Content content) {

  }

  /**
   * Generates a 402 Payment Required result.
   *
   * @param content the HTTP response body
   * @param charset the charset into which the content should be encoded (e.g. "UTF-8")
   * @
   */
  public static Result paymentRequired(Content content, String charset) {

  }

  /**
   * Generates a 402 Payment Required result.
   *
   * @param content HTTP response body, encoded as a UTF-8 string
   * @
   */
  public static Result paymentRequired(String content) {

  }

  /**
   * Generates a 402 Payment Required result.
   *
   * @param content the HTTP response body
   * @param charset the charset into which the content should be encoded (e.g. "UTF-8")
   * @
   */
  public static Result paymentRequired(String content, String charset) {

  }

  /**
   * Generates a 402 Payment Required result.
   *
   * @param content the result's body content as a play-json object. It will be encoded as a UTF-8
   *     string.
   * @
   */
  public static Result paymentRequired(JsonNode content) {

  }

  /**
   * Generates a 402 Payment Required result.
   *
   * @param content the result's body content as a play-json object
   * @param charset the charset into which the json should be encoded
   * @
   * @deprecated As of 2.6.0, use paymentRequired(JsonNode, JsonEncoding)
   */
  @Deprecated
  public static Result paymentRequired(JsonNode content, String charset) {

  }

  /**
   * Generates a 402 Payment Required result.
   *
   * @param content the result's body content as a play-json object
   * @param encoding the encoding into which the json should be encoded
   * @
   */
  public static Result paymentRequired(JsonNode content, JsonEncoding encoding) {

  }

  /**
   * Generates a 402 Payment Required result.
   *
   * @param content the result's body content
   * @
   */
  public static Result paymentRequired(byte[] content) {

  }

  /**
   * Generates a 402 Payment Required result.
   *
   * @param content the input stream containing data to chunk over
   * @
   */
  public static Result paymentRequired(InputStream content) {

  }

  /**
   * Generates a 402 Payment Required result.
   *
   * @param content the input stream containing data to chunk over
   * @param contentLength the length of the provided content in bytes.
   * @
   */
  public static Result paymentRequired(InputStream content, long contentLength) {

  }

  /**
   * Generates a 402 Payment Required result.
   *
   * @param content The file to send.
   * @
   */
  public static Result paymentRequired(File content) {

  }

  /**
   * Generates a 402 Payment Required result.
   *
   * @param content The file to send.
   * @param inline Whether the file should be sent inline, or as an attachment.
   * @
   */
  public static Result paymentRequired(File content, boolean inline) {

  }

  /**
   * Generates a 402 Payment Required result.
   *
   * @param content The file to send.
   * @param filename The name to send the file as.
   * @
   */
  public static Result paymentRequired(File content, String filename) {

  }

  /**
   * Generates a 403 Forbidden result.
   *
   * @
   */
  public static StatusHeader forbidden() {

  }

  /**
   * Generates a 403 Forbidden result.
   *
   * @param content the HTTP response body
   * @
   */
/*   public static Result forbidden(Content content) {

  } */

  /**
   * Generates a 403 Forbidden result.
   *
   * @param content the HTTP response body
   * @param charset the charset into which the content should be encoded (e.g. "UTF-8")
   * @
   */
  public static Result forbidden(Content content, String charset) {

  }

  /**
   * Generates a 403 Forbidden result.
   *
   * @param content HTTP response body, encoded as a UTF-8 string
   * @
   */
  public static Result forbidden(String content) {

  }

  /**
   * Generates a 403 Forbidden result.
   *
   * @param content the HTTP response body
   * @param charset the charset into which the content should be encoded (e.g. "UTF-8")
   * @
   */
  public static Result forbidden(String content, String charset) {

  }

  /**
   * Generates a 403 Forbidden result.
   *
   * @param content the result's body content as a play-json object. It will be encoded as a UTF-8
   *     string.
   * @
   */
  public static Result forbidden(JsonNode content) {

  }

  /**
   * Generates a 403 Forbidden result.
   *
   * @param content the result's body content as a play-json object
   * @param charset the charset into which the json should be encoded
   * @
   * @deprecated As of 2.6.0, use forbidden(JsonNode, JsonEncoding)
   */
  @Deprecated
  public static Result forbidden(JsonNode content, String charset) {

  }

  /**
   * Generates a 403 Forbidden result.
   *
   * @param content the result's body content as a play-json object
   * @param encoding the encoding into which the json should be encoded
   * @
   */
  public static Result forbidden(JsonNode content, JsonEncoding encoding) {

  }

  /**
   * Generates a 403 Forbidden result.
   *
   * @param content the result's body content
   * @
   */
  public static Result forbidden(byte[] content) {

  }

  /**
   * Generates a 403 Forbidden result.
   *
   * @param content the input stream containing data to chunk over
   * @
   */
  public static Result forbidden(InputStream content) {

  }

  /**
   * Generates a 403 Forbidden result.
   *
   * @param content the input stream containing data to chunk over
   * @param contentLength the length of the provided content in bytes.
   * @
   */
  public static Result forbidden(InputStream content, long contentLength) {

  }

  /**
   * Generates a 403 Forbidden result.
   *
   * @param content The file to send.
   * @
   */
  public static Result forbidden(File content) {

  }

  /**
   * Generates a 403 Forbidden result.
   *
   * @param content The file to send.
   * @param inline Whether the file should be sent inline, or as an attachment.
   * @
   */
  public static Result forbidden(File content, boolean inline) {

  }

  /**
   * Generates a 403 Forbidden result.
   *
   * @param content The file to send.
   * @param filename The name to send the file as.
   * @
   */
  public static Result forbidden(File content, String filename) {

  }

  /**
   * Generates a 404 Not Found result.
   *
   * @
   */
  public static StatusHeader notFound() {

  }

  /**
   * Generates a 404 Not Found result.
   *
   * @param content the HTTP response body
   * @
   */
/*   public static Result notFound(Content content) {

  } */

  /**
   * Generates a 404 Not Found result.
   *
   * @param content the HTTP response body
   * @param charset the charset into which the content should be encoded (e.g. "UTF-8")
   * @
   */
  public static Result notFound(Content content, String charset) {

  }

  /**
   * Generates a 404 Not Found result.
   *
   * @param content HTTP response body, encoded as a UTF-8 string
   * @
   */
  public static Result notFound(String content) {

  }

  /**
   * Generates a 404 Not Found result.
   *
   * @param content the HTTP response body
   * @param charset the charset into which the content should be encoded (e.g. "UTF-8")
   * @
   */
  public static Result notFound(String content, String charset) {

  }

  /**
   * Generates a 404 Not Found result.
   *
   * @param content the result's body content as a play-json object. It will be encoded as a UTF-8
   *     string.
   * @
   */
  public static Result notFound(JsonNode content) {

  }

  /**
   * Generates a 404 Not Found result.
   *
   * @param content the result's body content as a play-json object
   * @param charset the charset into which the json should be encoded
   * @
   * @deprecated As of 2.6.0, use notFound(JsonNode, JsonEncoding
   */
  @Deprecated
  public static Result notFound(JsonNode content, String charset) {

  }

  /**
   * Generates a 404 Not Found result.
   *
   * @param content the result's body content as a play-json object
   * @param encoding the encoding into which the json should be encoded
   * @
   */
  public static Result notFound(JsonNode content, JsonEncoding encoding) {

  }

  /**
   * Generates a 404 Not Found result.
   *
   * @param content the result's body content
   * @
   */
  public static Result notFound(byte[] content) {

  }

  /**
   * Generates a 404 Not Found result.
   *
   * @param content the input stream containing data to chunk over
   * @
   */
  public static Result notFound(InputStream content) {

  }

  /**
   * Generates a 404 Not Found result.
   *
   * @param content the input stream containing data to chunk over
   * @param contentLength the length of the provided content in bytes.
   * @
   */
  public static Result notFound(InputStream content, long contentLength) {

  }

  /**
   * Generates a 404 Not Found result.
   *
   * @param content The file to send.
   * @
   */
  public static Result notFound(File content) {

  }

  /**
   * Generates a 404 Not Found result.
   *
   * @param content The file to send.
   * @param inline Whether the file should be sent inline, or as an attachment.
   * @
   */
  public static Result notFound(File content, boolean inline) {

  }

  /**
   * Generates a 404 Not Found result.
   *
   * @param content The file to send.
   * @param filename The name to send the file as.
   * @
   */
  public static Result notFound(File content, String filename) {

  }

  /**
   * Generates a 406 Not Acceptable result.
   *
   * @
   */
  public static StatusHeader notAcceptable() {

  }

  /**
   * Generates a 406 Not Acceptable result.
   *
   * @param content the HTTP response body
   * @
   */
/*   public static Result notAcceptable(Content content) {

  } */

  /**
   * Generates a 406 Not Acceptable result.
   *
   * @param content the HTTP response body
   * @param charset the charset into which the content should be encoded (e.g. "UTF-8")
   * @
   */
  public static Result notAcceptable(Content content, String charset) {

  }

  /**
   * Generates a 406 Not Acceptable result.
   *
   * @param content HTTP response body, encoded as a UTF-8 string
   * @
   */
  public static Result notAcceptable(String content) {

  }

  /**
   * Generates a 406 Not Acceptable result.
   *
   * @param content the HTTP response body
   * @param charset the charset into which the content should be encoded (e.g. "UTF-8")
   * @
   */
  public static Result notAcceptable(String content, String charset) {

  }

  /**
   * Generates a 406 Not Acceptable result.
   *
   * @param content the result's body content as a play-json object. It will be encoded as a UTF-8
   *     string.
   * @
   */
  public static Result notAcceptable(JsonNode content) {

  }

  /**
   * Generates a 406 Not Acceptable result.
   *
   * @param content the result's body content as a play-json object
   * @param encoding the encoding into which the json should be encoded
   * @
   */
  public static Result notAcceptable(JsonNode content, JsonEncoding encoding) {

  }

  /**
   * Generates a 406 Not Acceptable result.
   *
   * @param content the result's body content
   * @
   */
  public static Result notAcceptable(byte[] content) {

  }

  /**
   * Generates a 406 Not Acceptable result.
   *
   * @param content the input stream containing data to chunk over
   * @
   */
  public static Result notAcceptable(InputStream content) {

  }

  /**
   * Generates a 406 Not Acceptable result.
   *
   * @param content the input stream containing data to chunk over
   * @param contentLength the length of the provided content in bytes.
   * @
   */
  public static Result notAcceptable(InputStream content, long contentLength) {

  }

  /**
   * Generates a 406 Not Acceptable result.
   *
   * @param content The file to send.
   * @
   */
  public static Result notAcceptable(File content) {

  }

  /**
   * Generates a 406 Not Acceptable result.
   *
   * @param content The file to send.
   * @param inline Whether the file should be sent inline, or as an attachment.
   * @
   */
  public static Result notAcceptable(File content, boolean inline) {

  }

  /**
   * Generates a 406 Not Acceptable result.
   *
   * @param content The file to send.
   * @param filename The name to send the file as.
   * @
   */
  public static Result notAcceptable(File content, String filename) {

  }

  /**
   * Generates a 415 Unsupported Media Type result.
   *
   * @
   */
  public static StatusHeader unsupportedMediaType() {

  }

  /**
   * Generates a 415 Unsupported Media Type result.
   *
   * @param content the HTTP response body
   * @
   */
/*   public static Result unsupportedMediaType(Content content) {

  } */

  /**
   * Generates a 415 Unsupported Media Type result.
   *
   * @param content the HTTP response body
   * @param charset the charset into which the content should be encoded (e.g. "UTF-8")
   * @
   */
  public static Result unsupportedMediaType(Content content, String charset) {

  }

  /**
   * Generates a 415 Unsupported Media Type result.
   *
   * @param content HTTP response body, encoded as a UTF-8 string
   * @
   */
  public static Result unsupportedMediaType(String content) {

  }

  /**
   * Generates a 415 Unsupported Media Type result.
   *
   * @param content the HTTP response body
   * @param charset the charset into which the content should be encoded (e.g. "UTF-8")
   * @
   */
  public static Result unsupportedMediaType(String content, String charset) {

  }

  /**
   * Generates a 415 Unsupported Media Type result.
   *
   * @param content the result's body content as a play-json object. It will be encoded as a UTF-8
   *     string.
   * @
   */
  public static Result unsupportedMediaType(JsonNode content) {

  }

  /**
   * Generates a 415 Unsupported Media Type result.
   *
   * @param content the result's body content as a play-json object
   * @param encoding the encoding into which the json should be encoded
   * @
   */
  public static Result unsupportedMediaType(JsonNode content, JsonEncoding encoding) {

  }

  /**
   * Generates a 415 Unsupported Media Type result.
   *
   * @param content the result's body content
   * @
   */
  public static Result unsupportedMediaType(byte[] content) {

  }

  /**
   * Generates a 415 Unsupported Media Type result.
   *
   * @param content the input stream containing data to chunk over
   * @
   */
  public static Result unsupportedMediaType(InputStream content) {

  }

  /**
   * Generates a 415 Unsupported Media Type result.
   *
   * @param content the input stream containing data to chunk over
   * @param contentLength the length of the provided content in bytes.
   * @
   */
  public static Result unsupportedMediaType(InputStream content, long contentLength) {

  }

  /**
   * Generates a 415 Unsupported Media Type result.
   *
   * @param content The file to send.
   * @
   */
  public static Result unsupportedMediaType(File content) {

  }

  /**
   * Generates a 415 Unsupported Media Type result.
   *
   * @param content The file to send.
   * @param inline Whether the file should be sent inline, or as an attachment.
   * @
   */
  public static Result unsupportedMediaType(File content, boolean inline) {

  }

  /**
   * Generates a 415 Unsupported Media Type result.
   *
   * @param content The file to send.
   * @param filename The name to send the file as.
   * @
   */
  public static Result unsupportedMediaType(File content, String filename) {

  }

  /**
   * Generates a 500 Internal Server Error result.
   *
   * @
   */
  public static StatusHeader internalServerError() {

  }

  /**
   * Generates a 500 Internal Server Error result.
   *
   * @param content the HTTP response body
   * @
   */
/*   public static Result internalServerError(Content content) {

  } */

  /**
   * Generates a 500 Internal Server Error result.
   *
   * @param content the HTTP response body
   * @param charset the charset into which the content should be encoded (e.g. "UTF-8")
   * @
   */
  public static Result internalServerError(Content content, String charset) {

  }

  /**
   * Generates a 500 Internal Server Error result.
   *
   * @param content HTTP response body, encoded as a UTF-8 string
   * @
   */
  public static Result internalServerError(String content) {

  }

  /**
   * Generates a 500 Internal Server Error result.
   *
   * @param content the HTTP response body
   * @param charset the charset into which the content should be encoded (e.g. "UTF-8")
   * @
   */
  public static Result internalServerError(String content, String charset) {

  }

  /**
   * Generates a 500 Internal Server Error result.
   *
   * @param content the result's body content as a play-json object. It will be encoded as a UTF-8
   *     string.
   * @
   */
  public static Result internalServerError(JsonNode content) {

  }

  /**
   * Generates a 500 Internal Server Error result.
   *
   * @param content the result's body content as a play-json object
   * @param charset the charset into which the json should be encoded
   * @
   * @deprecated As of 2.6.0, use internalServerError(JsonNode, JsonEncoding)
   */
  @Deprecated
  public static Result internalServerError(JsonNode content, String charset) {

  }

  /**
   * Generates a 500 Internal Server Error result.
   *
   * @param content the result's body content as a play-json object
   * @param encoding the encoding into which the json should be encoded
   * @
   */
  public static Result internalServerError(JsonNode content, JsonEncoding encoding) {

  }

  /**
   * Generates a 500 Internal Server Error result.
   *
   * @param content the result's body content
   * @
   */
  public static Result internalServerError(byte[] content) {

  }

  /**
   * Generates a 500 Internal Server Error result.
   *
   * @param content the input stream containing data to chunk over
   * @
   */
  public static Result internalServerError(InputStream content) {

  }

  /**
   * Generates a 500 Internal Server Error result.
   *
   * @param content the input stream containing data to chunk over
   * @param contentLength the length of the provided content in bytes.
   * @
   */
  public static Result internalServerError(InputStream content, long contentLength) {

  }

  /**
   * Generates a 500 Internal Server Error result.
   *
   * @param content The file to send.
   * @
   */
  public static Result internalServerError(File content) {

  }

  /**
   * Generates a 500 Internal Server Error result.
   *
   * @param content The file to send.
   * @param inline Whether the file should be sent inline, or as an attachment.
   * @
   */
  public static Result internalServerError(File content, boolean inline) {

  }

  /**
   * Generates a 500 Internal Server Error result.
   *
   * @param content The file to send.
   * @param filename The name to send the file as.
   * @
   */
  public static Result internalServerError(File content, String filename) {

  }

  /**
   * Generates a 301 Moved Permanently result.
   *
   * @param url The url to redirect.
   * @
   */
  public static Result movedPermanently(String url) {

  }

  /**
   * Generates a 301 Moved Permanently result.
   *
   * @param call Call defining the url to redirect (typically comes from reverse router).
   * @
   */
  public static Result movedPermanently(Call call) {

  }

  /**
   * Generates a 302 Found result.
   *
   * @param url The url to redirect.
   * @
   */
  public static Result found(String url) {

  }

  /**
   * Generates a 302 Found result.
   *
   * @param call Call defining the url to redirect (typically comes from reverse router).
   * @
   */
  public static Result found(Call call) {

  }

  /**
   * Generates a 303 See Other result.
   *
   * @param url The url to redirect.
   * @
   */
  public static Result seeOther(String url) {

  }

  /**
   * Generates a 303 See Other result.
   *
   * @param call Call defining the url to redirect (typically comes from reverse router).
   * @
   */
  public static Result seeOther(Call call) {

  }

  /**
   * Generates a 303 See Other result.
   *
   * @param url The url to redirect.
   * @
   */
  public static Result redirect(String url) {
  }

  /**
   * Generates a 303 See Other result.
   *
   * @param call Call defining the url to redirect (typically comes from reverse router).
   * @
   */
  public static Result redirect(Call call) {

  }

  /**
   * Generates a 307 Temporary Redirect result.
   *
   * @param url The url to redirect.
   * @
   */
  public static Result temporaryRedirect(String url) {

  }

  /**
   * Generates a 307 Temporary Redirect result.
   *
   * @param call Call defining the url to redirect (typically comes from reverse router).
   * @
   */
  public static Result temporaryRedirect(Call call) {

  }

  /**
   * Generates a 308 Permanent Redirect result.
   *
   * @param url The url to redirect.
   * @
   */
  public static Result permanentRedirect(String url) {

  }

  /**
   * Generates a 308 Permanent Redirect result.
   *
   * @param call Call defining the url to redirect (typically comes from reverse router).
   * @
   */
  public static Result permanentRedirect(Call call) {

  }
}