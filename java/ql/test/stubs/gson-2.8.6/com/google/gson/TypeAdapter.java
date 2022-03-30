/*
 * Copyright (C) 2011 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.google.gson;

import com.google.gson.stream.JsonReader;
import java.io.IOException;
import java.io.Reader;
import java.io.Writer;

public abstract class TypeAdapter<T> {
  /**
   * Converts {@code value} to a JSON document and writes it to {@code out}.
   * Unlike Gson's similar {@link Gson#toJson(JsonElement, Appendable) toJson}
   * method, this write is strict. Create a {@link
   * JsonWriter#setLenient(boolean) lenient} {@code JsonWriter} and call
   * {@link #write(com.google.gson.stream.JsonWriter, Object)} for lenient
   * writing.
   *
   * @param value the Java object to convert. May be null.
   * @since 2.2
   */
  public final void toJson(Writer out, T value) throws IOException {
  }

  /**
   * This wrapper method is used to make a type adapter null tolerant. In general, a
   * type adapter is required to handle nulls in write and read methods. Here is how this
   * is typically done:<br>
   * <pre>   {@code
   *
   * Gson gson = new GsonBuilder().registerTypeAdapter(Foo.class,
   *   new TypeAdapter<Foo>() {
   *     public Foo read(JsonReader in) throws IOException {
   *       if (in.peek() == JsonToken.NULL) {
   *         in.nextNull();
   *         return null;
   *       }
   *       // read a Foo from in and return it
   *     }
   *     public void write(JsonWriter out, Foo src) throws IOException {
   *       if (src == null) {
   *         out.nullValue();
   *         return;
   *       }
   *       // write src as JSON to out
   *     }
   *   }).create();
   * }</pre>
   * You can avoid this boilerplate handling of nulls by wrapping your type adapter with
   * this method. Here is how we will rewrite the above example:
   * <pre>   {@code
   *
   * Gson gson = new GsonBuilder().registerTypeAdapter(Foo.class,
   *   new TypeAdapter<Foo>() {
   *     public Foo read(JsonReader in) throws IOException {
   *       // read a Foo from in and return it
   *     }
   *     public void write(JsonWriter out, Foo src) throws IOException {
   *       // write src as JSON to out
   *     }
   *   }.nullSafe()).create();
   * }</pre>
   * Note that we didn't need to check for nulls in our type adapter after we used nullSafe.
   */
  public final TypeAdapter<T> nullSafe() {
    return null;
  }

  /**
   * Converts {@code value} to a JSON document. Unlike Gson's similar {@link
   * Gson#toJson(Object) toJson} method, this write is strict. Create a {@link
   * JsonWriter#setLenient(boolean) lenient} {@code JsonWriter} and call
   * {@link #write(com.google.gson.stream.JsonWriter, Object)} for lenient
   * writing.
   *
   * @param value the Java object to convert. May be null.
   * @since 2.2
   */
  public final String toJson(T value) {
    return null;
  }

  /**
   * Reads one JSON value (an array, object, string, number, boolean or null)
   * and converts it to a Java object. Returns the converted object.
   *
   * @return the converted Java object. May be null.
   */
  public abstract T read(JsonReader in) throws IOException;

  /**
   * Converts the JSON document in {@code in} to a Java object. Unlike Gson's
   * similar {@link Gson#fromJson(java.io.Reader, Class) fromJson} method, this
   * read is strict. Create a {@link JsonReader#setLenient(boolean) lenient}
   * {@code JsonReader} and call {@link #read(JsonReader)} for lenient reading.
   *
   * @return the converted Java object. May be null.
   * @since 2.2
   */
  public final T fromJson(Reader in) throws IOException {
    return null;
  }

  /**
   * Converts the JSON document in {@code json} to a Java object. Unlike Gson's
   * similar {@link Gson#fromJson(String, Class) fromJson} method, this read is
   * strict. Create a {@link JsonReader#setLenient(boolean) lenient} {@code
   * JsonReader} and call {@link #read(JsonReader)} for lenient reading.
   *
   * @return the converted Java object. May be null.
   * @since 2.2
   */
  public final T fromJson(String json) throws IOException {
    return null;
  }
}
