/*
 * Copyright 2002-2019 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.springframework.validation;

import org.springframework.context.support.DefaultMessageSourceResolvable;
import org.springframework.lang.Nullable;

public class ObjectError extends DefaultMessageSourceResolvable {

  public ObjectError(String objectName, String defaultMessage) { super(""); }

  public ObjectError(
      String objectName,
      @Nullable String[] codes,
      @Nullable Object[] arguments,
      @Nullable String defaultMessage) { super(""); }

  public String getObjectName() {
    return null;
  }

  public void wrap(Object source) {}

  public <T> T unwrap(Class<T> sourceType) {
    return null;
  }

  public boolean contains(Class<?> sourceType) {
    return false;
  }

  @Override
  public boolean equals(@Nullable Object other) {
    return false;
  }

  @Override
  public int hashCode() {
    return 0;
  }

  @Override
  public String toString() {
    return "";
  }
}
