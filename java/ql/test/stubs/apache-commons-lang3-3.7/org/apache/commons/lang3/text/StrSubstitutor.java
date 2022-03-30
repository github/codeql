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
package org.apache.commons.lang3.text;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;


public class StrSubstitutor {
    public static <V> String replace(final Object source, final Map<String, V> valueMap) {
      return null;
    }

    public static <V> String replace(final Object source, final Map<String, V> valueMap, final String prefix, final String suffix) {
      return null;
    }

    public static String replace(final Object source, final Properties valueProperties) {
      return null;
    }

    public static String replaceSystemProperties(final Object source) {
      return null;
    }

    public StrSubstitutor() {
    }

    public <V> StrSubstitutor(final Map<String, V> valueMap) {
    }

    public <V> StrSubstitutor(final Map<String, V> valueMap, final String prefix, final String suffix) {
    }

    public <V> StrSubstitutor(final Map<String, V> valueMap, final String prefix, final String suffix,
                              final char escape) {
    }

    public <V> StrSubstitutor(final Map<String, V> valueMap, final String prefix, final String suffix,
                              final char escape, final String valueDelimiter) {
    }

    public StrSubstitutor(final StrLookup<?> variableResolver) {
    }

    public StrSubstitutor(final StrLookup<?> variableResolver, final String prefix, final String suffix,
                          final char escape) {
    }

    public StrSubstitutor(final StrLookup<?> variableResolver, final String prefix, final String suffix,
                          final char escape, final String valueDelimiter) {
    }

    public StrSubstitutor(
            final StrLookup<?> variableResolver, final StrMatcher prefixMatcher, final StrMatcher suffixMatcher,
            final char escape) {
    }

    public StrSubstitutor(
            final StrLookup<?> variableResolver, final StrMatcher prefixMatcher, final StrMatcher suffixMatcher,
            final char escape, final StrMatcher valueDelimiterMatcher) {
    }

    public String replace(final String source) {
      return null;
    }

    public String replace(final String source, final int offset, final int length) {
      return null;
    }

    public String replace(final char[] source) {
      return null;
    }

    public String replace(final char[] source, final int offset, final int length) {
      return null;
    }

    public String replace(final StringBuffer source) {
      return null;
    }

    public String replace(final StringBuffer source, final int offset, final int length) {
      return null;
    }

    public String replace(final CharSequence source) {
      return null;
    }

    public String replace(final CharSequence source, final int offset, final int length) {
      return null;
    }

    public String replace(final StrBuilder source) {
      return null;
    }

    public String replace(final StrBuilder source, final int offset, final int length) {
      return null;
    }

    public String replace(final Object source) {
      return null;
    }

    public boolean replaceIn(final StringBuffer source) {
      return false;
    }

    public boolean replaceIn(final StringBuffer source, final int offset, final int length) {
      return false;
    }

    public boolean replaceIn(final StringBuilder source) {
      return false;
    }

    public boolean replaceIn(final StringBuilder source, final int offset, final int length) {
      return false;
    }

    public boolean replaceIn(final StrBuilder source) {
      return false;
    }

    public boolean replaceIn(final StrBuilder source, final int offset, final int length) {
      return false;
    }

    public char getEscapeChar() {
      return 0;
    }

    public void setEscapeChar(final char escapeCharacter) {
    }

    public StrMatcher getVariablePrefixMatcher() {
      return null;
    }

    public StrSubstitutor setVariablePrefixMatcher(final StrMatcher prefixMatcher) {
      return null;
    }

    public StrSubstitutor setVariablePrefix(final char prefix) {
      return null;
    }

    public StrSubstitutor setVariablePrefix(final String prefix) {
      return null;
    }

    public StrMatcher getVariableSuffixMatcher() {
      return null;
    }

    public StrSubstitutor setVariableSuffixMatcher(final StrMatcher suffixMatcher) {
      return null;
    }

    public StrSubstitutor setVariableSuffix(final char suffix) {
      return null;
    }

    public StrSubstitutor setVariableSuffix(final String suffix) {
      return null;
    }

    public StrMatcher getValueDelimiterMatcher() {
      return null;
    }

    public StrSubstitutor setValueDelimiterMatcher(final StrMatcher valueDelimiterMatcher) {
      return null;
    }

    public StrSubstitutor setValueDelimiter(final char valueDelimiter) {
      return null;
    }

    public StrSubstitutor setValueDelimiter(final String valueDelimiter) {
      return null;
    }

    public StrLookup<?> getVariableResolver() {
      return null;
    }

    public void setVariableResolver(final StrLookup<?> variableResolver) {
    }

    public boolean isEnableSubstitutionInVariables() {
      return false;
    }

    public void setEnableSubstitutionInVariables(
            final boolean enableSubstitutionInVariables) {
    }

    public boolean isPreserveEscapes() {
      return false;
    }

    public void setPreserveEscapes(final boolean preserveEscapes) {
    }

}
