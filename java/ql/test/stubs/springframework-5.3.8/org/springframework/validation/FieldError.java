/*
 * Copyright 2002-2018 the original author or authors.
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

import org.springframework.lang.Nullable;

public class FieldError extends ObjectError {
  public FieldError(String objectName, String field, String defaultMessage) { super("", ""); }

  public FieldError(
      String objectName,
      String field,
      @Nullable Object rejectedValue,
      boolean bindingFailure,
      @Nullable String[] codes,
      @Nullable Object[] arguments,
      @Nullable String defaultMessage) { super("", ""); }

  public String getField() {
    return null;
  }

  @Nullable
  public Object getRejectedValue() {
    return null;
  }

  public boolean isBindingFailure() {
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
    return null;
  }
}
