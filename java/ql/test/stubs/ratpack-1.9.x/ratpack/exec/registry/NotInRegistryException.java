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

package ratpack.exec.registry;

import com.google.common.reflect.TypeToken;

/**
 * Thrown when a request is made for an object that a registry cannot provide.
 *
 * @see Registry#get(Class)
 */
public class NotInRegistryException extends RuntimeException {

  private static final long serialVersionUID = 0;

  /**
   * Constructs the exception.
   *
   * @param type The requested type of the object
   */
  public NotInRegistryException(TypeToken<?> type) {
    this(String.format("No object for type '%s' in registry", type));
  }

  /**
   * Constructor.
   *
   * @param message The exception message
   */
  public NotInRegistryException(String message) {
    super(message);
  }
}
