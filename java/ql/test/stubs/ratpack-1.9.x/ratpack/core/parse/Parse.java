/*
 * Copyright 2014 the original author or authors.
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

package ratpack.core.parse;

import com.google.common.reflect.TypeToken;
import ratpack.core.handling.Context;

import java.util.Optional;

/**
 * The specification of a particular parse.
 * <p>
 * Construct instances via the {@link #of} methods.
 *
 * @param <T> the type of object to construct from the request body
 * @param <O> the type of object that provides options/configuration for the parsing
 * @see Context#parse(Parse)
 * @see Parser
 * @see ParserSupport
 */
public class Parse<T, O> {

  /**
   * The type of object to construct from the request body.
   *
   * @return the type of object to construct from the request body
   */
  public TypeToken<T> getType() {
    return null;
  }

  /**
   * The type of object that provides options/configuration for the parsing.
   * <p>
   * For any parse request, no options may be specified.
   * Parser implementations should throw an exception if they require an options object when none is supplied.
   *
   * @return the type of object that provides options/configuration for the parsing
   */
  public Optional<O> getOpts() {
    return null;
  }

  /**
   * Creates a parse object.
   *
   * @param type the type of object to construct from the request body
   * @param opts the options object
   * @param <T> the type of object to construct from the request body
   * @param <O> the type of object that provides options/configuration for the parsing
   * @return a parse instance from the given arguments
   */
  public static <T, O> Parse<T, O> of(TypeToken<T> type, O opts) {
    return null;
  }

  /**
   * Creates a parse object, with no options.
   *
   * @param type the type of object to construct from the request body
   * @param <T> the type of object to construct from the request body
   * @return a parse instance to the given type
   */
  public static <T> Parse<T, ?> of(TypeToken<T> type) {
    return null;
  }

  /**
   * Creates a parse object.
   *
   * @param type the type of object to construct from the request body
   * @param opts the options object
   * @param <T> the type of object to construct from the request body
   * @param <O> the type of object that provides options/configuration for the parsing
   * @return a parse instance from the given arguments
   */
  public static <T, O> Parse<T, O> of(Class<T> type, O opts) {
    return null;
  }

  /**
   * Creates a parse object, with no options.
   *
   * @param type the type of object to construct from the request body
   * @param <T> the type of object to construct from the request body
   * @return a parse instance to the given type
   */
  public static <T> Parse<T, ?> of(Class<T> type) {
    return null;
  }

}
