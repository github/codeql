/*
 * Copyright 2002-2019 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.springframework.util;

import java.nio.charset.Charset;
import java.util.Collection;
import java.util.Enumeration;
import java.util.Locale;
import java.util.Properties;
import java.util.Set;
import java.util.TimeZone;
import org.springframework.lang.Nullable;

public abstract class StringUtils {
  public static boolean isEmpty(@Nullable Object str) {
    return false;
  }

  public static boolean hasLength(@Nullable CharSequence str) {
    return false;
  }

  public static boolean hasLength(@Nullable String str) {
    return false;
  }

  public static boolean hasText(@Nullable CharSequence str) {
    return false;
  }

  public static boolean hasText(@Nullable String str) {
    return false;
  }

  public static boolean containsWhitespace(@Nullable CharSequence str) {
    return false;
  }

  public static boolean containsWhitespace(@Nullable String str) {
    return false;
  }

  public static String trimWhitespace(String str) {
    return null;
  }

  public static String trimAllWhitespace(String str) {
    return null;
  }

  public static String trimLeadingWhitespace(String str) {
    return null;
  }

  public static String trimTrailingWhitespace(String str) {
    return null;
  }

  public static String trimLeadingCharacter(String str, char leadingCharacter) {
    return null;
  }

  public static String trimTrailingCharacter(String str, char trailingCharacter) {
    return null;
  }

  public static boolean startsWithIgnoreCase(@Nullable String str, @Nullable String prefix) {
    return false;
  }

  public static boolean endsWithIgnoreCase(@Nullable String str, @Nullable String suffix) {
    return false;
  }

  public static boolean substringMatch(CharSequence str, int index, CharSequence substring) {
    return false;
  }

  public static int countOccurrencesOf(String str, String sub) {
    return 0;
  }

  public static String replace(String inString, String oldPattern, @Nullable String newPattern) {
    return null;
  }

  public static String delete(String inString, String pattern) {
    return null;
  }

  public static String deleteAny(String inString, @Nullable String charsToDelete) {
    return null;
  }

  public static String quote(@Nullable String str) {
    return null;
  }

  public static Object quoteIfString(@Nullable Object obj) {
    return null;
  }

  public static String unqualify(String qualifiedName) {
    return null;
  }

  public static String unqualify(String qualifiedName, char separator) {
    return null;
  }

  public static String capitalize(String str) {
    return null;
  }

  public static String uncapitalize(String str) {
    return null;
  }

  public static String getFilename(@Nullable String path) {
    return null;
  }

  public static String getFilenameExtension(@Nullable String path) {
    return null;
  }

  public static String stripFilenameExtension(String path) {
    return null;
  }

  public static String applyRelativePath(String path, String relativePath) {
    return null;
  }

  public static String cleanPath(String path) {
    return null;
  }

  public static boolean pathEquals(String path1, String path2) {
    return false;
  }

  public static String uriDecode(String source, Charset charset) {
    return null;
  }

  public static Locale parseLocale(String localeValue) {
    return null;
  }

  public static Locale parseLocaleString(String localeString) {
    return null;
  }

  public static String toLanguageTag(Locale locale) {
    return null;
  }

  public static TimeZone parseTimeZoneString(String timeZoneString) {
    return null;
  }

  public static String[] toStringArray(@Nullable Collection<String> collection) {
    return null;
  }

  public static String[] toStringArray(@Nullable Enumeration<String> enumeration) {
    return null;
  }

  public static String[] addStringToArray(@Nullable String[] array, String str) {
    return null;
  }

  public static String[] concatenateStringArrays(
      @Nullable String[] array1, @Nullable String[] array2) {
    return null;
  }

  public static String[] mergeStringArrays(@Nullable String[] array1, @Nullable String[] array2) {
    return null;
  }

  public static String[] sortStringArray(String[] array) {
    return null;
  }

  public static String[] trimArrayElements(String[] array) {
    return null;
  }

  public static String[] removeDuplicateStrings(String[] array) {
    return null;
  }

  public static String[] split(@Nullable String toSplit, @Nullable String delimiter) {
    return null;
  }

  public static Properties splitArrayElementsIntoProperties(String[] array, String delimiter) {
    return null;
  }

  public static Properties splitArrayElementsIntoProperties(
      String[] array, String delimiter, @Nullable String charsToDelete) {
    return null;
  }

  public static String[] tokenizeToStringArray(@Nullable String str, String delimiters) {
    return null;
  }

  public static String[] tokenizeToStringArray(
      @Nullable String str, String delimiters, boolean trimTokens, boolean ignoreEmptyTokens) {
    return null;
  }

  public static String[] delimitedListToStringArray(
      @Nullable String str, @Nullable String delimiter) {
    return null;
  }

  public static String[] delimitedListToStringArray(
      @Nullable String str, @Nullable String delimiter, @Nullable String charsToDelete) {
    return null;
  }

  public static String[] commaDelimitedListToStringArray(@Nullable String str) {
    return null;
  }

  public static Set<String> commaDelimitedListToSet(@Nullable String str) {
    return null;
  }

  public static String collectionToDelimitedString(
      @Nullable Collection<?> coll, String delim, String prefix, String suffix) {
    return null;
  }

  public static String collectionToDelimitedString(@Nullable Collection<?> coll, String delim) {
    return null;
  }

  public static String collectionToCommaDelimitedString(@Nullable Collection<?> coll) {
    return null;
  }

  public static String arrayToDelimitedString(@Nullable Object[] arr, String delim) {
    return null;
  }

  public static String arrayToCommaDelimitedString(@Nullable Object[] arr) {
    return null;
  }
}
