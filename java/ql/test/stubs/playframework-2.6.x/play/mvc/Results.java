package play.mvc;

import static play.mvc.Http.Status.*;

import akka.util.ByteString;
import com.fasterxml.jackson.core.JsonEncoding;
import com.fasterxml.jackson.databind.JsonNode;
import java.io.File;
import java.io.InputStream;
import play.api.mvc.StatusHeader;
import play.twirl.api.Content;

public class Results {

  private static final String UTF8 = "utf-8";

  public static StatusHeader status(int status) {
    return null;
  }

  public static Result status(int status, Content content) {
    return null;
  }

  public static Result status(int status, Content content, String charset) {
    return null;
  }

  public static Result status(int status, String content) {
    return null;
  }

  public static Result status(int status, String content, String charset) {
    return null;
  }

  public static Result status(int status, JsonNode content) {
    return null;
  }

  @Deprecated
  public static Result status(int status, JsonNode content, String charset) {
    return null;
  }

  public static Result status(int status, JsonNode content, JsonEncoding encoding) {
    return null;
  }

  public static Result status(int status, byte[] content) {
    return null;
  }

  public static Result status(int status, ByteString content) {
    return null;
  }

  public static Result status(int status, InputStream content) {
    return null;
  }

  public static Result status(int status, InputStream content, long contentLength) {
    return null;
  }

  public static Result status(int status, File content) {
    return null;
  }

  public static Result status(int status, File content, boolean inline) {
    return null;
  }

  public static Result status(int status, File content, String fileName) {
    return null;
  }

  public static StatusHeader noContent() {
    return null;
  }

  public static StatusHeader ok() {
    return null;
  }

  public static Result ok(Content content) {
    return null;
  }

  public static Result ok(Content content, String charset) {
    return null;
  }

  public static Result ok(String content) {
    return null;
  }

  public static Result ok(String content, String charset) {
    return null;
  }

  public static Result ok(JsonNode content) {
    return null;
  }

  @Deprecated
  public static Result ok(JsonNode content, String charset) {
    return null;
  }

  public static Result ok(JsonNode content, JsonEncoding encoding) {
    return null;
  }

  public static Result ok(byte[] content) {
    return null;
  }

  public static Result ok(InputStream content) {
    return null;
  }

  public static Result ok(InputStream content, long contentLength) {
    return null;
  }

  public static Result ok(File content) {
    return null;
  }

  public static Result ok(File content, boolean inline) {
    return null;
  }

  public static Result ok(File content, String filename) {
    return null;
  }

  public static StatusHeader created() {
    return null;
  }

  public static Result created(Content content, String charset) {
    return null;
  }

  public static Result created(String content) {
    return null;
  }

  public static Result created(String content, String charset) {
    return null;
  }

  public static Result created(JsonNode content) {
    return null;
  }

  @Deprecated
  public static Result created(JsonNode content, String charset) {
    return null;
  }

  public static Result created(JsonNode content, JsonEncoding encoding) {
    return null;
  }

  public static Result created(byte[] content) {
    return null;
  }

  public static Result created(InputStream content) {
    return null;
  }

  public static Result created(InputStream content, long contentLength) {
    return null;
  }

  public static Result created(File content) {
    return null;
  }

  public static Result created(File content, boolean inline) {
    return null;
  }

  public static Result created(File content, String filename) {
    return null;
  }

  public static StatusHeader badRequest() {
    return null;
  }

  public static Result badRequest(Content content, String charset) {
    return null;
  }

  public static Result badRequest(String content) {
    return null;
  }

  public static Result badRequest(String content, String charset) {
    return null;
  }

  public static Result badRequest(JsonNode content) {
    return null;
  }

  @Deprecated
  public static Result badRequest(JsonNode content, String charset) {
    return null;
  }

  public static Result badRequest(JsonNode content, JsonEncoding encoding) {
    return null;
  }

  public static Result badRequest(byte[] content) {
    return null;
  }

  public static Result badRequest(InputStream content) {
    return null;
  }

  public static Result badRequest(InputStream content, long contentLength) {
    return null;
  }

  public static Result badRequest(File content) {
    return null;
  }

  public static Result badRequest(File content, boolean inline) {
    return null;
  }

  public static Result badRequest(File content, String filename) {
    return null;
  }

  public static StatusHeader unauthorized() {
    return null;
  }

  public static Result unauthorized(Content content, String charset) {
    return null;
  }

  public static Result unauthorized(String content) {
    return null;
  }

  public static Result unauthorized(String content, String charset) {
    return null;
  }

  public static Result unauthorized(JsonNode content) {
    return null;
  }

  @Deprecated
  public static Result unauthorized(JsonNode content, String charset) {
    return null;
  }

  public static Result unauthorized(JsonNode content, JsonEncoding encoding) {
    return null;
  }

  public static Result unauthorized(byte[] content) {
    return null;
  }

  public static Result unauthorized(InputStream content) {
    return null;
  }

  public static Result unauthorized(InputStream content, long contentLength) {
    return null;
  }

  public static Result unauthorized(File content) {
    return null;
  }

  public static Result unauthorized(File content, boolean inline) {
    return null;
  }

  public static Result unauthorized(File content, String filename) {
    return null;
  }

  public static StatusHeader paymentRequired() {
    return null;
  }

  public static Result paymentRequired(Content content) {
    return null;
  }

  public static Result paymentRequired(Content content, String charset) {
    return null;
  }

  public static Result paymentRequired(String content) {
    return null;
  }

  public static Result paymentRequired(String content, String charset) {
    return null;
  }

  public static Result paymentRequired(JsonNode content) {
    return null;
  }

  @Deprecated
  public static Result paymentRequired(JsonNode content, String charset) {
    return null;
  }

  public static Result paymentRequired(JsonNode content, JsonEncoding encoding) {
    return null;
  }

  public static Result paymentRequired(byte[] content) {
    return null;
  }

  public static Result paymentRequired(InputStream content) {
    return null;
  }

  public static Result paymentRequired(InputStream content, long contentLength) {
    return null;
  }

  public static Result paymentRequired(File content) {
    return null;
  }

  public static Result paymentRequired(File content, boolean inline) {
    return null;
  }

  public static Result paymentRequired(File content, String filename) {
    return null;
  }

  public static StatusHeader forbidden() {
    return null;
  }

  public static Result forbidden(Content content, String charset) {
    return null;
  }

  public static Result forbidden(String content) {
    return null;
  }

  public static Result forbidden(String content, String charset) {
    return null;
  }

  public static Result forbidden(JsonNode content) {
    return null;
  }

  @Deprecated
  public static Result forbidden(JsonNode content, String charset) {
    return null;
  }

  public static Result forbidden(JsonNode content, JsonEncoding encoding) {
    return null;
  }

  public static Result forbidden(byte[] content) {
    return null;
  }

  public static Result forbidden(InputStream content) {
    return null;
  }

  public static Result forbidden(InputStream content, long contentLength) {
    return null;
  }

  public static Result forbidden(File content) {
    return null;
  }

  public static Result forbidden(File content, boolean inline) {
    return null;
  }

  public static Result forbidden(File content, String filename) {
    return null;
  }

  public static StatusHeader notFound() {
    return null;
  }

  public static Result notFound(Content content, String charset) {
    return null;
  }

  public static Result notFound(String content) {
    return null;
  }

  public static Result notFound(String content, String charset) {
    return null;
  }

  public static Result notFound(JsonNode content) {
    return null;
  }

  @Deprecated
  public static Result notFound(JsonNode content, String charset) {
    return null;
  }

  public static Result notFound(JsonNode content, JsonEncoding encoding) {
    return null;
  }

  public static Result notFound(byte[] content) {
    return null;
  }

  public static Result notFound(InputStream content) {
    return null;
  }

  public static Result notFound(InputStream content, long contentLength) {
    return null;
  }

  public static Result notFound(File content) {
    return null;
  }

  public static Result notFound(File content, boolean inline) {
    return null;
  }

  public static Result notFound(File content, String filename) {
    return null;
  }

  public static StatusHeader notAcceptable() {
    return null;
  }

  public static Result notAcceptable(Content content, String charset) {
    return null;
  }

  public static Result notAcceptable(String content) {
    return null;
  }

  public static Result notAcceptable(String content, String charset) {
    return null;
  }

  public static Result notAcceptable(JsonNode content) {
    return null;
  }

  public static Result notAcceptable(JsonNode content, JsonEncoding encoding) {
    return null;
  }

  public static Result notAcceptable(byte[] content) {
    return null;
  }

  public static Result notAcceptable(InputStream content) {
    return null;
  }

  public static Result notAcceptable(InputStream content, long contentLength) {
    return null;
  }

  public static Result notAcceptable(File content) {
    return null;
  }

  public static Result notAcceptable(File content, boolean inline) {
    return null;
  }

  public static Result notAcceptable(File content, String filename) {
    return null;
  }

  public static StatusHeader unsupportedMediaType() {
    return null;
  }

  public static Result unsupportedMediaType(Content content, String charset) {
    return null;
  }

  public static Result unsupportedMediaType(String content) {
    return null;
  }

  public static Result unsupportedMediaType(String content, String charset) {
    return null;
  }

  public static Result unsupportedMediaType(JsonNode content) {
    return null;
  }

  public static Result unsupportedMediaType(JsonNode content, JsonEncoding encoding) {
    return null;
  }

  public static Result unsupportedMediaType(byte[] content) {
    return null;
  }

  public static Result unsupportedMediaType(InputStream content) {
    return null;
  }

  public static Result unsupportedMediaType(InputStream content, long contentLength) {
    return null;
  }

  public static Result unsupportedMediaType(File content) {
    return null;
  }

  public static Result unsupportedMediaType(File content, boolean inline) {
    return null;
  }

  public static Result unsupportedMediaType(File content, String filename) {
    return null;
  }

  public static StatusHeader internalServerError() {
    return null;
  }

  public static Result internalServerError(Content content, String charset) {
    return null;
  }

  public static Result internalServerError(String content) {
    return null;
  }

  public static Result internalServerError(String content, String charset) {
    return null;
  }

  public static Result internalServerError(JsonNode content) {
    return null;
  }

  @Deprecated
  public static Result internalServerError(JsonNode content, String charset) {
    return null;
  }

  public static Result internalServerError(JsonNode content, JsonEncoding encoding) {
    return null;
  }

  public static Result internalServerError(byte[] content) {
    return null;
  }

  public static Result internalServerError(InputStream content) {
    return null;
  }

  public static Result internalServerError(InputStream content, long contentLength) {
    return null;
  }

  public static Result internalServerError(File content) {
    return null;
  }

  public static Result internalServerError(File content, boolean inline) {
    return null;
  }

  public static Result internalServerError(File content, String filename) {
    return null;
  }

  public static Result movedPermanently(String url) {
    return null;
  }

  public static Result movedPermanently(Call call) {
    return null;
  }

  public static Result found(String url) {
    return null;
  }

  public static Result found(Call call) {
    return null;
  }

  public static Result seeOther(String url) {
    return null;
  }

  public static Result seeOther(Call call) {
    return null;
  }

  public static Result redirect(String url) {
    return null;
  }

  public static Result redirect(Call call) {
    return null;
  }

  public static Result temporaryRedirect(String url) {
    return null;
  }

  public static Result temporaryRedirect(Call call) {
    return null;
  }

  public static Result permanentRedirect(String url) {
    return null;
  }

  public static Result permanentRedirect(Call call) {
    return null;
  }
}
