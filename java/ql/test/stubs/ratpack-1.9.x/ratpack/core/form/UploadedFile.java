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

package ratpack.core.form;

import ratpack.core.http.TypedData;
import ratpack.func.Nullable;

/**
 * A file that was uploaded via a form.
 *
 * @see Form
 */
public interface UploadedFile extends TypedData {

  /**
   * The name given for the file.
   *
   * @return The name given for the file, or {@code null} if no name was provided.
   */
  @Nullable
  String getFileName();

}
