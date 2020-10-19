/*
 * Copyright (C) 2009 The Guava Authors
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
import java.util.List;
import java.util.Map;

public final class Splitter {

  public static Splitter on(final String separator) {
    return null;
  }

  public Splitter omitEmptyStrings() {
    return null;;
  }

  public Iterable<String> split(final CharSequence sequence) {
    return null;
  }

  public List<String> splitToList(CharSequence sequence) {
    return null;
  }

  public MapSplitter withKeyValueSeparator(String separator) {
    return null;
  }

  public static final class MapSplitter {
    public Map<String, String> split(CharSequence sequence) {
      return null;
    }
  }
}
