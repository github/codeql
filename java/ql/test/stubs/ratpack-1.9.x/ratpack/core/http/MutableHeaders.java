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

import java.time.Instant;
import java.util.Calendar;
import java.util.Date;

/**
 * A set of HTTP headers that can be changed.
 */
public interface MutableHeaders extends Headers {

  /**
   * Adds a new header with the specified name and value.
   * <p>
   * Will not replace any existing values for the header.
   * <p>
   * Objects of type {@link Instant}, {@link Calendar} or {@link Date} will be converted to a
   * RFC 7231 date/time string.
   *
   * @param name The name of the header
   * @param value The value of the header
   * @return this
   */
  MutableHeaders add(CharSequence name, Object value);

  /**
   * Sets the (only) value for the header with the specified name.
   * <p>
   * All existing values for the same header will be removed.
   * <p>
   * Objects of type {@link Instant}, {@link Calendar} or {@link Date} will be converted to a
   * RFC 7231 date/time string.
   *
   * @param name The name of the header
   * @param value The value of the header
   * @return this
   */
  MutableHeaders set(CharSequence name, Object value);

  /**
   * Set a header with the given date as the value.
   *
   * @param name The name of the header
   * @param value The date value
   * @return this
   */
  MutableHeaders setDate(CharSequence name, Date value);

  /**
   * Set a header with the given date as the value.
   *
   * @param name the name of the header
   * @param value the date value
   * @return this
   * @since 1.4
   */
  default MutableHeaders setDate(CharSequence name, Instant value) {
    return setDate(name, new Date(value.toEpochMilli()));
  }

  /**
   * Sets a new header with the specified name and values.
   * <p>
   * All existing values for the same header will be removed.
   * <p>
   * Objects of type {@link Instant}, {@link Calendar} or {@link Date} will be converted to a
   * RFC 7231 date/time string.
   *
   * @param name The name of the header
   * @param values The values of the header
   * @return this
   */
  MutableHeaders set(CharSequence name, Iterable<?> values);

  /**
   * Removes the header with the specified name.
   *
   * @param name The name of the header to remove.
   * @return this
   */
  MutableHeaders remove(CharSequence name);

  /**
   * Removes all headers from this message.
   *
   * @return this
   */
  MutableHeaders clear();

  MutableHeaders copy(Headers headers);

}
