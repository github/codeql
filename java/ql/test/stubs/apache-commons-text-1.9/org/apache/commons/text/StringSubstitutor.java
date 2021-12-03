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
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Properties;

import org.apache.commons.text.lookup.StringLookup;
import org.apache.commons.text.matcher.StringMatcher;

public class StringSubstitutor {
    public static StringSubstitutor createInterpolator() {
      return null;
    }

    public static <V> String replace(final Object source, final Map<String, V> valueMap) {
      return null;
    }

    public static <V> String replace(final Object source, final Map<String, V> valueMap, final String prefix,
        final String suffix) {
      return null;
    }

    public static String replace(final Object source, final Properties valueProperties) {
      return null;
    }

    public static String replaceSystemProperties(final Object source) {
      return null;
    }

    public StringSubstitutor() {
    }

    public <V> StringSubstitutor(final Map<String, V> valueMap) {
    }

    public <V> StringSubstitutor(final Map<String, V> valueMap, final String prefix, final String suffix) {
    }

    public <V> StringSubstitutor(final Map<String, V> valueMap, final String prefix, final String suffix,
        final char escape) {
    }

    public <V> StringSubstitutor(final Map<String, V> valueMap, final String prefix, final String suffix,
        final char escape, final String valueDelimiter) {
    }

    public StringSubstitutor(final StringLookup variableResolver) {
    }

    public StringSubstitutor(final StringLookup variableResolver, final String prefix, final String suffix,
        final char escape) {
    }

    public StringSubstitutor(final StringLookup variableResolver, final String prefix, final String suffix,
        final char escape, final String valueDelimiter) {
    }

    public StringSubstitutor(final StringLookup variableResolver, final StringMatcher prefixMatcher,
        final StringMatcher suffixMatcher, final char escape) {
    }

    public StringSubstitutor(final StringLookup variableResolver, final StringMatcher prefixMatcher,
        final StringMatcher suffixMatcher, final char escape, final StringMatcher valueDelimiterMatcher) {
    }

    public StringSubstitutor(final StringSubstitutor other) {
    }

    public char getEscapeChar() {
      return 0;
    }

    public StringLookup getStringLookup() {
      return null;
    }

    public StringMatcher getValueDelimiterMatcher() {
      return null;
    }

    public StringMatcher getVariablePrefixMatcher() {
      return null;
    }

    public StringMatcher getVariableSuffixMatcher() {
      return null;
    }

    public boolean isDisableSubstitutionInValues() {
      return false;
    }

    public boolean isEnableSubstitutionInVariables() {
      return false;
    }

    public boolean isEnableUndefinedVariableException() {
      return false;
    }

    public boolean isPreserveEscapes() {
      return false;
    }

    public String replace(final char[] source) {
      return null;
    }

    public String replace(final char[] source, final int offset, final int length) {
      return null;
    }

    public String replace(final CharSequence source) {
      return null;
    }

    public String replace(final CharSequence source, final int offset, final int length) {
      return null;
    }

    public String replace(final Object source) {
      return null;
    }

    public String replace(final String source) {
      return null;
    }

    public String replace(final String source, final int offset, final int length) {
      return null;
    }

    public String replace(final StringBuffer source) {
      return null;
    }

    public String replace(final StringBuffer source, final int offset, final int length) {
      return null;
    }

    public String replace(final TextStringBuilder source) {
      return null;
    }

    public String replace(final TextStringBuilder source, final int offset, final int length) {
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

    public boolean replaceIn(final TextStringBuilder source) {
      return false;
    }

    public boolean replaceIn(final TextStringBuilder source, final int offset, final int length) {
      return false;
    }

    public StringSubstitutor setDisableSubstitutionInValues(final boolean disableSubstitutionInValues) {
      return null;
    }

    public StringSubstitutor setEnableSubstitutionInVariables(final boolean enableSubstitutionInVariables) {
      return null;
    }

    public StringSubstitutor setEnableUndefinedVariableException(final boolean failOnUndefinedVariable) {
      return null;
    }

    public StringSubstitutor setEscapeChar(final char escapeCharacter) {
      return null;
    }

    public StringSubstitutor setPreserveEscapes(final boolean preserveEscapes) {
      return null;
    }

    public StringSubstitutor setValueDelimiter(final char valueDelimiter) {
      return null;
    }

    public StringSubstitutor setValueDelimiter(final String valueDelimiter) {
      return null;
    }

    public StringSubstitutor setValueDelimiterMatcher(final StringMatcher valueDelimiterMatcher) {
      return null;
    }

    public StringSubstitutor setVariablePrefix(final char prefix) {
      return null;
    }

    public StringSubstitutor setVariablePrefix(final String prefix) {
      return null;
    }

    public StringSubstitutor setVariablePrefixMatcher(final StringMatcher prefixMatcher) {
      return null;
    }

    public StringSubstitutor setVariableResolver(final StringLookup variableResolver) {
      return null;
    }

    public StringSubstitutor setVariableSuffix(final char suffix) {
      return null;
    }

    public StringSubstitutor setVariableSuffix(final String suffix) {
      return null;
    }

    public StringSubstitutor setVariableSuffixMatcher(final StringMatcher suffixMatcher) {
      return null;
    }

}
