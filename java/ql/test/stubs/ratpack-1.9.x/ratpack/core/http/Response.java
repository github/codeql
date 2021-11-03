/*
 * Copyright 2013 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package ratpack.core.http;

import com.google.common.reflect.TypeToken;
import io.netty.buffer.ByteBuf;
import io.netty.handler.codec.http.cookie.Cookie;
import ratpack.core.handling.Context;
import ratpack.exec.api.NonBlocking;

import java.nio.file.Path;
import java.util.Set;
import java.util.function.Supplier;

/**
 * A response to a request.
 * <p>
 * The headers and status are configured, before committing the response with one of the {@link #send} methods.
 */
public interface Response {

  /**
   * A type token for this type.
   *
   * @since 1.1
   */
  TypeToken<Response> TYPE = null;

  /**
   * Creates a new cookie with the given name and value.
   * <p>
   * The cookie will have no expiry. Use the returned cookie object to fine tune the cookie.
   *
   * @param name The name of the cookie
   * @param value The value of the cookie
   * @return The cookie that will be sent
   */
  Cookie cookie(String name, String value);

  /**
   * Adds a cookie to the response with a 0 max-age, forcing the client to expire it.
   * <p>
   * If the cookie that you want to expire has an explicit path, you must use {@link Cookie#setPath(String)} on the return
   * value of this method to have the cookie expire.
   *
   * @param name The name of the cookie to expire.
   * @return The created cookie
   */
  Cookie expireCookie(String name);

  /**
   * The cookies that are to be part of the response.
   * <p>
   * The cookies are mutable.
   *
   * @return The cookies that are to be part of the response.
   */
  Set<Cookie> getCookies();

  /**
   * The response headers.
   *
   * @return The response headers.
   */
  MutableHeaders getHeaders();

  /**
   * Sets the status line of the response.
   * <p>
   * The message used will be the standard for the code.
   *
   * @param code The status code of the response to use when it is sent.
   * @return This
   */
  default Response status(int code) {
    return null;
  }

  /**
   * Sends the response back to the client, with no body.
   */
  @NonBlocking
  void send();

  Response contentTypeIfNotSet(Supplier<CharSequence> contentType);

  /**
   * Sends the response, using "{@code text/plain}" as the content type and the given string as the response body.
   * <p>
   * Equivalent to calling "{@code send\("text/plain", text)}.
   *
   * @param text The text to render as a plain text response.
   */
  @NonBlocking
  void send(String text);

  /**
   * Sends the response, using the given content type and string as the response body.
   * <p>
   * The string will be sent in "utf8" encoding, and the given content type will have this appended.
   * That is, given a {@code contentType} of "{@code application/json}" the actual value for the {@code Content-Type}
   * header will be "{@code application/json;charset=utf8}".
   * <p>
   * The value given for content type will override any previously set value for this header.
   *  @param contentType The value of the content type header
   * @param body The string to render as the body of the response
   */
  @NonBlocking
  void send(CharSequence contentType, String body);

  /**
   * Sends the response, using "{@code application/octet-stream}" as the content type (if a content type hasn't
   * already been set) and the given byte array as the response body.
   *
   * @param bytes The response body
   */
  @NonBlocking
  void send(byte[] bytes);

  /**
   * Sends the response, using the given content type and byte array as the response body.
   *  @param contentType The value of the {@code Content-Type} header
   * @param bytes The response body
   */
  @NonBlocking
  void send(CharSequence contentType, byte[] bytes);

  /**
   * Sends the response, using "{@code application/octet-stream}" as the content type (if a content type hasn't
   * already been set) and the given bytes as the response body.
   *
   * @param buffer The response body
   */
  @NonBlocking
  void send(ByteBuf buffer);

  /**
   * Sends the response, using the given content type and bytes as the response body.
   *  @param contentType The value of the {@code Content-Type} header
   * @param buffer The response body
   */
  @NonBlocking
  void send(CharSequence contentType, ByteBuf buffer);

  /**
   * Sets the response {@code Content-Type} header.
   *
   * @param contentType The value of the {@code Content-Type} header
   * @return This
   */
  Response contentType(CharSequence contentType);

  /**
   * Sets the response {@code Content-Type} header, if it has not already been set.
   *
   * @param contentType The value of the {@code Content-Type} header
   * @return This
   */
  default Response contentTypeIfNotSet(CharSequence contentType) {
    return null;
  }

  /**
   * Sends the response, using the file as the response body.
   * <p>
   * This method does not set the content length, content type or anything else.
   * It is generally preferable to use the {@link Context#render(Object)} method with a file/path object,
   * or an {@link Chain#files(Action)}.
   *
   * @param file the response body
   */
  @NonBlocking
  void sendFile(Path file);

  /**
   * Prevents the response from being compressed.
   *
   * @return {@code this}
   */
  Response noCompress();

  /**
   * Forces the closing of the current connection, even if the client requested it to be kept alive.
   * <p>
   * This method can be used when it is desirable to force the client's connection to close, defeating HTTP keep alive.
   * This can be desirable in some networking environments where rate limiting or throttling is performed via edge routers or similar.
   * <p>
   * This method simply calls {@code getHeaders().set("Connection", "close")}, which has the same effect.
   *
   * @return {@code this}
   * @since 1.1
   */
  default Response forceCloseConnection() {
    return null;
  }
}
