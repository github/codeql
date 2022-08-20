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

package ratpack.core.render;

/**
 * Thrown when a request is made to render an object, but no suitable renderer can be found.
 */
public class NoSuchRendererException extends RuntimeException {

  private static final long serialVersionUID = 0;

  /**
   * Constructor.
   *
   * @param object The object to be rendered.
   */
  public NoSuchRendererException(Object object) {
    super("No renderer for object '" + object + "' of type '" + object.getClass() + "'");
  }

}
