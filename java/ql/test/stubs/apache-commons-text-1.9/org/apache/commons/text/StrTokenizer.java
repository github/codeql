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
package org.apache.commons.text;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.ListIterator;
import java.util.NoSuchElementException;


public class StrTokenizer implements ListIterator<String>, Cloneable {
    public static StrTokenizer getCSVInstance() {
      return null;
    }

    public static StrTokenizer getCSVInstance(final char[] input) {
      return null;
    }

    public static StrTokenizer getCSVInstance(final String input) {
      return null;
    }

    public static StrTokenizer getTSVInstance() {
      return null;
    }

    public static StrTokenizer getTSVInstance(final char[] input) {
      return null;
    }

    public static StrTokenizer getTSVInstance(final String input) {
      return null;
    }

    public StrTokenizer() {
    }

    public StrTokenizer(final char[] input) {
    }

    public StrTokenizer(final char[] input, final char delim) {
    }

    public StrTokenizer(final char[] input, final char delim, final char quote) {
    }

    public StrTokenizer(final char[] input, final String delim) {
    }

    public StrTokenizer(final char[] input, final StrMatcher delim) {
    }

    public StrTokenizer(final char[] input, final StrMatcher delim, final StrMatcher quote) {
    }

    public StrTokenizer(final String input) {
    }

    public StrTokenizer(final String input, final char delim) {
    }

    public StrTokenizer(final String input, final char delim, final char quote) {
    }

    public StrTokenizer(final String input, final String delim) {
    }

    public StrTokenizer(final String input, final StrMatcher delim) {
    }

    public StrTokenizer(final String input, final StrMatcher delim, final StrMatcher quote) {
    }

    @Override
    public void add(final String obj) {
    }

    @Override
    public Object clone() {
      return null;
    }

    public String getContent() {
      return null;
    }

    public StrMatcher getDelimiterMatcher() {
      return null;
    }

    public StrMatcher getIgnoredMatcher() {
      return null;
    }

    public StrMatcher getQuoteMatcher() {
      return null;
    }

    public String[] getTokenArray() {
      return null;
    }

    public List<String> getTokenList() {
      return null;
    }

    public StrMatcher getTrimmerMatcher() {
      return null;
    }

    @Override
    public boolean hasNext() {
      return false;
    }

    @Override
    public boolean hasPrevious() {
      return false;
    }

    public boolean isEmptyTokenAsNull() {
      return false;
    }

    public boolean isIgnoreEmptyTokens() {
      return false;
    }

    @Override
    public String next() {
      return null;
    }

    @Override
    public int nextIndex() {
      return 0;
    }

    public String nextToken() {
      return null;
    }

    @Override
    public String previous() {
      return null;
    }

    @Override
    public int previousIndex() {
      return 0;
    }

    public String previousToken() {
      return null;
    }

    @Override
    public void remove() {
    }

    public StrTokenizer reset() {
      return null;
    }

    public StrTokenizer reset(final char[] input) {
      return null;
    }

    public StrTokenizer reset(final String input) {
      return null;
    }

    @Override
    public void set(final String obj) {
    }

    public StrTokenizer setDelimiterChar(final char delim) {
      return null;
    }

    public StrTokenizer setDelimiterMatcher(final StrMatcher delim) {
      return null;
    }

    public StrTokenizer setDelimiterString(final String delim) {
      return null;
    }

    public StrTokenizer setEmptyTokenAsNull(final boolean emptyAsNull) {
      return null;
    }

    public StrTokenizer setIgnoredChar(final char ignored) {
      return null;
    }

    public StrTokenizer setIgnoredMatcher(final StrMatcher ignored) {
      return null;
    }

    public StrTokenizer setIgnoreEmptyTokens(final boolean ignoreEmptyTokens) {
      return null;
    }

    public StrTokenizer setQuoteChar(final char quote) {
      return null;
    }

    public StrTokenizer setQuoteMatcher(final StrMatcher quote) {
      return null;
    }

    public StrTokenizer setTrimmerMatcher(final StrMatcher trimmer) {
      return null;
    }

    public int size() {
      return 0;
    }

    @Override
    public String toString() {
      return null;
    }

}
