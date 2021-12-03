/*
 * Copyright (C) 2008 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.google.gson;

import java.lang.reflect.Type;

public final class GsonBuilder {
  /**
   * Creates a GsonBuilder instance that can be used to build Gson with various configuration
   * settings. GsonBuilder follows the builder pattern, and it is typically used by first
   * invoking various configuration methods to set desired options, and finally calling
   * {@link #create()}.
   */
  public GsonBuilder() {
  }

  /**
   * Constructs a GsonBuilder instance from a Gson instance. The newly constructed GsonBuilder
   * has the same configuration as the previously built Gson instance.
   *
   * @param gson the gson instance whose configuration should by applied to a new GsonBuilder.
   */
  GsonBuilder(Gson gson) {
  }

  /**
   * Configures Gson for custom serialization or deserialization. This method combines the
   * registration of an {@link TypeAdapter}, {@link InstanceCreator}, {@link JsonSerializer}, and a
   * {@link JsonDeserializer}. It is best used when a single object {@code typeAdapter} implements
   * all the required interfaces for custom serialization with Gson. If a type adapter was
   * previously registered for the specified {@code type}, it is overwritten.
   *
   * <p>This registers the type specified and no other types: you must manually register related
   * types! For example, applications registering {@code boolean.class} should also register {@code
   * Boolean.class}.
   *
   * @param type the type definition for the type adapter being registered
   * @param typeAdapter This object must implement at least one of the {@link TypeAdapter},
   * {@link InstanceCreator}, {@link JsonSerializer}, and a {@link JsonDeserializer} interfaces.
   * @return a reference to this {@code GsonBuilder} object to fulfill the "Builder" pattern
   */
  public GsonBuilder registerTypeAdapter(Type type, Object typeAdapter) {
    return null;
  }

  /**
   * Register a factory for type adapters. Registering a factory is useful when the type
   * adapter needs to be configured based on the type of the field being processed. Gson
   * is designed to handle a large number of factories, so you should consider registering
   * them to be at par with registering an individual type adapter.
   *
   * @since 2.1
   */
  public GsonBuilder registerTypeAdapterFactory(TypeAdapterFactory factory) {
    return null;
  }

  /**
   * Configures Gson for custom serialization or deserialization for an inheritance type hierarchy.
   * This method combines the registration of a {@link TypeAdapter}, {@link JsonSerializer} and
   * a {@link JsonDeserializer}. If a type adapter was previously registered for the specified
   * type hierarchy, it is overridden. If a type adapter is registered for a specific type in
   * the type hierarchy, it will be invoked instead of the one registered for the type hierarchy.
   *
   * @param baseType the class definition for the type adapter being registered for the base class
   *        or interface
   * @param typeAdapter This object must implement at least one of {@link TypeAdapter},
   *        {@link JsonSerializer} or {@link JsonDeserializer} interfaces.
   * @return a reference to this {@code GsonBuilder} object to fulfill the "Builder" pattern
   * @since 1.7
   */
  public GsonBuilder registerTypeHierarchyAdapter(Class<?> baseType, Object typeAdapter) {
    return null;
  }

  /**
   * Creates a {@link Gson} instance based on the current configuration. This method is free of
   * side-effects to this {@code GsonBuilder} instance and hence can be called multiple times.
   *
   * @return an instance of Gson configured with the options currently set in this builder
   */
  public Gson create() {
      return null;
  }
}