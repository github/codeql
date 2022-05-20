/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.commons.text.matcher;


public interface StringMatcher {
    default StringMatcher andThen(final StringMatcher stringMatcher) {
      return null;
    }

    default int isMatch(final char[] buffer, final int pos) {
      return 0;
    }

    int isMatch(char[] buffer, int start, int bufferStart, int bufferEnd);

    default int isMatch(final CharSequence buffer, final int pos) {
      return 0;
    }

    default int isMatch(final CharSequence buffer, final int start, final int bufferStart, final int bufferEnd) {
      return 0;
    }

    default int size() {
      return 0;
    }

}
