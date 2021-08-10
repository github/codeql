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

package org.springframework.context.support;

import java.io.Serializable;
import org.springframework.context.MessageSourceResolvable;
import org.springframework.lang.Nullable;

public class DefaultMessageSourceResolvable implements MessageSourceResolvable, Serializable {
  public DefaultMessageSourceResolvable(String code) {}

  public DefaultMessageSourceResolvable(String[] codes) {}

  public DefaultMessageSourceResolvable(String[] codes, String defaultMessage) {}

  public DefaultMessageSourceResolvable(String[] codes, Object[] arguments) {}

  public DefaultMessageSourceResolvable(
      @Nullable String[] codes, @Nullable Object[] arguments, @Nullable String defaultMessage) {}

  public DefaultMessageSourceResolvable(MessageSourceResolvable resolvable) {}

  public String getCode() {
    return null;
  }

  @Override
  public String[] getCodes() {
    return null;
  }

  @Override
  public Object[] getArguments() {
    return null;
  }

  @Override
  public String getDefaultMessage() {
    return null;
  }

  public boolean shouldRenderDefaultMessage() {
    return false;
  }

  @Override
  public String toString() {
    return null;
  }

  @Override
  public boolean equals(@Nullable Object other) {
    return false;
  }

  @Override
  public int hashCode() {
    return 0;
  }

  protected final String resolvableToString() {
    return null;
  }
}
