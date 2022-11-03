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

import java.util.List;
import org.springframework.lang.Nullable;

public interface Errors {
  String getObjectName();

  void setNestedPath(String nestedPath);

  String getNestedPath();

  void pushNestedPath(String subPath);

  void popNestedPath() throws IllegalStateException;

  void reject(String errorCode);

  void reject(String errorCode, String defaultMessage);

  void reject(String errorCode, @Nullable Object[] errorArgs, @Nullable String defaultMessage);

  void rejectValue(@Nullable String field, String errorCode);

  void rejectValue(@Nullable String field, String errorCode, String defaultMessage);

  void rejectValue(
      @Nullable String field,
      String errorCode,
      @Nullable Object[] errorArgs,
      @Nullable String defaultMessage);

  void addAllErrors(Errors errors);

  boolean hasErrors();

  int getErrorCount();

  List<ObjectError> getAllErrors();

  boolean hasGlobalErrors();

  int getGlobalErrorCount();

  List<ObjectError> getGlobalErrors();

  ObjectError getGlobalError();

  boolean hasFieldErrors();

  int getFieldErrorCount();

  List<FieldError> getFieldErrors();

  FieldError getFieldError();

  boolean hasFieldErrors(String field);

  int getFieldErrorCount(String field);

  List<FieldError> getFieldErrors(String field);

  FieldError getFieldError(String field);

  Object getFieldValue(String field);

  Class<?> getFieldType(String field);
}
