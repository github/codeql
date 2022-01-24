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

import com.google.common.collect.ImmutableListMultimap;
import ratpack.func.Nullable;

/**
 * A structured value for a Content-Type header value.
 * <p>
 * Can also represent a non existent (i.e. empty) value.
 */
@SuppressWarnings("UnusedDeclaration")
public interface MediaType {

  /**
   * {@value}.
   */
  String PLAIN_TEXT_UTF8 = "text/plain;charset=utf-8";

  /**
   * {@value}.
   */
  String APPLICATION_JSON = "application/json";

  /**
   * {@value}.
   */
  String JSON_SUFFIX = "+json";

  /**
   * {@value}.
   */
  String APPLICATION_FORM = "application/x-www-form-urlencoded";

  /**
   * {@value}.
   */
  String TEXT_HTML = "text/html";

  /**
   * The type without parameters.
   * <p>
   * Given a mime type of "text/plain;charset=utf-8", returns "text/plain".
   * <p>
   * May be null to represent no content type.
   *
   * @return The mime type without parameters, or null if this represents the absence of a value.
   */
  @Nullable
  String getType();

  /**
   * The multimap containing parameters of the mime type.
   * <p>
   * Given a mime type of "application/json;charset=utf-8", the {@code get("charset")} returns {@code  ["utf-8"]}".
   * May be empty, never null.
   * <p>
   * All param names have been lower cased. The {@code charset} parameter values has been lower cased too.
   *
   * @return the immutable multimap of the media type params.
   */
  ImmutableListMultimap<String, String> getParams();

  /**
   * The value of the "charset" parameter.
   *
   * @return the value of the charset parameter, or {@code null} if the no charset parameter was specified
   */
  @Nullable
  String getCharset();

  /**
   * The value of the "charset" parameter, or the given default value of no charset was specified.
   *
   * @param defaultValue the value if this type has no charset
   * @return the value of the charset parameter, or the given default
   */
  String getCharset(String defaultValue);

  /**
   * True if this type starts with "{@code text/}".
   *
   * @return True if this type starts with "{@code text/}".
   */
  boolean isText();

  /**
   * True if this type equals {@value #APPLICATION_JSON}, or ends with {@value #JSON_SUFFIX}.
   *
   * @return if this represents a JSON like type
   */
  boolean isJson();

  /**
   * True if this type equals {@value #APPLICATION_FORM}.
   *
   * @return True if this type equals {@value #APPLICATION_FORM}.
   */
  boolean isForm();

  /**
   * True if this type equals {@value #TEXT_HTML}.
   *
   * @return True if this type equals {@value #TEXT_HTML}.
   */
  boolean isHtml();

  /**
   * True if this represents the absence of a value (i.e. no Content-Type header)
   *
   * @return True if this represents the absence of a value (i.e. no Content-Type header)
   */
  boolean isEmpty();
}
