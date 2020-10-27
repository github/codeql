/*
 * Copyright (C) 2008 The Guava Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License
 * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing permissions and limitations under
 * the License.
 */

package com.google.common.base;

import java.util.Iterator;
import java.util.Map;

public class Joiner {
  public static Joiner on(String separator) {
    return null;
  }

  public final StringBuilder appendTo(StringBuilder builder, Object first, Object second, Object... rest) {
    return null;
  }

  public final String join(Object first, Object second, Object... rest) {
    return null;
  }

  public Joiner useForNull(final String nullText) {
    return null;
  }

  public Joiner skipNulls() {
    return null;
  }

  public MapJoiner withKeyValueSeparator(String keyValueSeparator) {
    return null;
  }

  public static final class MapJoiner {
    public StringBuilder appendTo(StringBuilder builder, Map<?, ?> map) {
      return null;
    }

    public String join(Map<?, ?> map) {
      return null;
    }

    public MapJoiner useForNull(String nullText) {
      return null;
    }
  }
}
