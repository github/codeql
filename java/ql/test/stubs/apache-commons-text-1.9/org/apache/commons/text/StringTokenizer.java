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

import java.util.List;
import java.util.ListIterator;

import org.apache.commons.text.matcher.StringMatcher;

public class StringTokenizer implements ListIterator<String>, Cloneable {
    public static StringTokenizer getCSVInstance() {
      return null;
    }

    public static StringTokenizer getCSVInstance(final char[] input) {
      return null;
    }

    public static StringTokenizer getCSVInstance(final String input) {
      return null;
    }

    public static StringTokenizer getTSVInstance() {
      return null;
    }

    public static StringTokenizer getTSVInstance(final char[] input) {
      return null;
    }

    public static StringTokenizer getTSVInstance(final String input) {
      return null;
    }

    public StringTokenizer() {
    }

    public StringTokenizer(final char[] input) {
    }

    public StringTokenizer(final char[] input, final char delim) {
    }

    public StringTokenizer(final char[] input, final char delim, final char quote) {
    }

    public StringTokenizer(final char[] input, final String delim) {
    }

    public StringTokenizer(final char[] input, final StringMatcher delim) {
    }

    public StringTokenizer(final char[] input, final StringMatcher delim, final StringMatcher quote) {
    }

    public StringTokenizer(final String input) {
    }

    public StringTokenizer(final String input, final char delim) {
    }

    public StringTokenizer(final String input, final char delim, final char quote) {
    }

    public StringTokenizer(final String input, final String delim) {
    }

    public StringTokenizer(final String input, final StringMatcher delim) {
    }

    public StringTokenizer(final String input, final StringMatcher delim, final StringMatcher quote) {
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

    public StringMatcher getDelimiterMatcher() {
      return null;
    }

    public StringMatcher getIgnoredMatcher() {
      return null;
    }

    public StringMatcher getQuoteMatcher() {
      return null;
    }

    public String[] getTokenArray() {
      return null;
    }

    public List<String> getTokenList() {
      return null;
    }

    public StringMatcher getTrimmerMatcher() {
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

    public StringTokenizer reset() {
      return null;
    }

    public StringTokenizer reset(final char[] input) {
      return null;
    }

    public StringTokenizer reset(final String input) {
      return null;
    }

    @Override
    public void set(final String obj) {
    }

    public StringTokenizer setDelimiterChar(final char delim) {
      return null;
    }

    public StringTokenizer setDelimiterMatcher(final StringMatcher delim) {
      return null;
    }

    public StringTokenizer setDelimiterString(final String delim) {
      return null;
    }

    public StringTokenizer setEmptyTokenAsNull(final boolean emptyAsNull) {
      return null;
    }

    public StringTokenizer setIgnoredChar(final char ignored) {
      return null;
    }

    public StringTokenizer setIgnoredMatcher(final StringMatcher ignored) {
      return null;
    }

    public StringTokenizer setIgnoreEmptyTokens(final boolean ignoreEmptyTokens) {
      return null;
    }

    public StringTokenizer setQuoteChar(final char quote) {
      return null;
    }

    public StringTokenizer setQuoteMatcher(final StringMatcher quote) {
      return null;
    }

    public StringTokenizer setTrimmerMatcher(final StringMatcher trimmer) {
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
