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
package org.apache.commons.lang3;

import java.io.UnsupportedEncodingException;
import java.nio.charset.Charset;
import java.text.Normalizer;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Objects;
import java.util.Set;
import java.util.StringJoiner;
import java.util.function.Supplier;
import java.util.regex.Pattern;


public class StringUtils {
    public static String abbreviate(final String str, final int maxWidth) {
      return null;
    }

    public static String abbreviate(final String str, final int offset, final int maxWidth) {
      return null;
    }

    public static String abbreviate(final String str, final String abbrevMarker, final int maxWidth) {
      return null;
    }

    public static String abbreviate(final String str, final String abbrevMarker, int offset, final int maxWidth) {
      return null;
    }

    public static String abbreviateMiddle(final String str, final String middle, final int length) {
      return null;
    }

    public static String appendIfMissing(final String str, final CharSequence suffix, final CharSequence... suffixes) {
      return null;
    }

    public static String appendIfMissingIgnoreCase(final String str, final CharSequence suffix, final CharSequence... suffixes) {
      return null;
    }

    public static String capitalize(final String str) {
      return null;
    }

    public static String center(final String str, final int size) {
      return null;
    }

    public static String center(String str, final int size, final char padChar) {
      return null;
    }

    public static String center(String str, final int size, String padStr) {
      return null;
    }

    public static String chomp(final String str) {
      return null;
    }

    public static String chomp(final String str, final String separator) {
      return null;
    }

    public static String chop(final String str) {
      return null;
    }

    public static int compare(final String str1, final String str2) {
      return 0;
    }

    public static int compare(final String str1, final String str2, final boolean nullIsLess) {
      return 0;
    }

    public static int compareIgnoreCase(final String str1, final String str2) {
      return 0;
    }

    public static int compareIgnoreCase(final String str1, final String str2, final boolean nullIsLess) {
      return 0;
    }

    public static boolean contains(final CharSequence seq, final CharSequence searchSeq) {
      return false;
    }

    public static boolean contains(final CharSequence seq, final int searchChar) {
      return false;
    }

    public static boolean containsAny(final CharSequence cs, final char... searchChars) {
      return false;
    }

    public static boolean containsAny(final CharSequence cs, final CharSequence searchChars) {
      return false;
    }

    public static boolean containsAny(final CharSequence cs, final CharSequence... searchCharSequences) {
      return false;
    }

    public static boolean containsAnyIgnoreCase(final CharSequence cs, final CharSequence... searchCharSequences) {
      return false;
    }

    public static boolean containsIgnoreCase(final CharSequence str, final CharSequence searchStr) {
      return false;
    }

    public static boolean containsNone(final CharSequence cs, final char... searchChars) {
      return false;
    }

    public static boolean containsNone(final CharSequence cs, final String invalidChars) {
      return false;
    }

    public static boolean containsOnly(final CharSequence cs, final char... valid) {
      return false;
    }

    public static boolean containsOnly(final CharSequence cs, final String validChars) {
      return false;
    }

    public static boolean containsWhitespace(final CharSequence seq) {
      return false;
    }

    public static int countMatches(final CharSequence str, final char ch) {
      return 0;
    }

    public static int countMatches(final CharSequence str, final CharSequence sub) {
      return 0;
    }

    public static <T extends CharSequence> T defaultIfBlank(final T str, final T defaultStr) {
      return null;
    }

    public static <T extends CharSequence> T defaultIfEmpty(final T str, final T defaultStr) {
      return null;
    }

    public static String defaultString(final String str) {
      return null;
    }

    public static String defaultString(final String str, final String defaultStr) {
      return null;
    }

    public static String deleteWhitespace(final String str) {
      return null;
    }

    public static String difference(final String str1, final String str2) {
      return null;
    }

    public static boolean endsWith(final CharSequence str, final CharSequence suffix) {
      return false;
    }

    public static boolean endsWithAny(final CharSequence sequence, final CharSequence... searchStrings) {
      return false;
    }

    public static boolean endsWithIgnoreCase(final CharSequence str, final CharSequence suffix) {
      return false;
    }

    public static boolean equals(final CharSequence cs1, final CharSequence cs2) {
      return false;
    }

    public static boolean equalsAny(final CharSequence string, final CharSequence... searchStrings) {
      return false;
    }

    public static boolean equalsAnyIgnoreCase(final CharSequence string, final CharSequence...searchStrings) {
      return false;
    }

    public static boolean equalsIgnoreCase(final CharSequence cs1, final CharSequence cs2) {
      return false;
    }

    public static <T extends CharSequence> T firstNonBlank(final T... values) {
      return null;
    }

    public static <T extends CharSequence> T firstNonEmpty(final T... values) {
      return null;
    }

    public static byte[] getBytes(final String string, final Charset charset) {
      return null;
    }

    public static byte[] getBytes(final String string, final String charset) throws UnsupportedEncodingException {
      return null;
    }

    public static String getCommonPrefix(final String... strs) {
      return null;
    }

    public static String getDigits(final String str) {
      return null;
    }

    public static int getFuzzyDistance(final CharSequence term, final CharSequence query, final Locale locale) {
      return 0;
    }

    public static <T extends CharSequence> T getIfBlank(final T str, final Supplier<T> defaultSupplier) {
      return null;
    }

    public static <T extends CharSequence> T getIfEmpty(final T str, final Supplier<T> defaultSupplier) {
      return null;
    }

    public static double getJaroWinklerDistance(final CharSequence first, final CharSequence second) {
      return 0;
    }

    public static int getLevenshteinDistance(CharSequence s, CharSequence t) {
      return 0;
    }

    public static int getLevenshteinDistance(CharSequence s, CharSequence t, final int threshold) {
      return 0;
    }

    public static int indexOf(final CharSequence seq, final CharSequence searchSeq) {
      return 0;
    }

    public static int indexOf(final CharSequence seq, final CharSequence searchSeq, final int startPos) {
      return 0;
    }

    public static int indexOf(final CharSequence seq, final int searchChar) {
      return 0;
    }

    public static int indexOf(final CharSequence seq, final int searchChar, final int startPos) {
      return 0;
    }

    public static int indexOfAny(final CharSequence cs, final char... searchChars) {
      return 0;
    }

    public static int indexOfAny(final CharSequence str, final CharSequence... searchStrs) {
      return 0;
    }

    public static int indexOfAny(final CharSequence cs, final String searchChars) {
      return 0;
    }

    public static int indexOfAnyBut(final CharSequence cs, final char... searchChars) {
      return 0;
    }

    public static int indexOfAnyBut(final CharSequence seq, final CharSequence searchChars) {
      return 0;
    }

    public static int indexOfDifference(final CharSequence... css) {
      return 0;
    }

    public static int indexOfDifference(final CharSequence cs1, final CharSequence cs2) {
      return 0;
    }

    public static int indexOfIgnoreCase(final CharSequence str, final CharSequence searchStr) {
      return 0;
    }

    public static int indexOfIgnoreCase(final CharSequence str, final CharSequence searchStr, int startPos) {
      return 0;
    }

    public static boolean isAllBlank(final CharSequence... css) {
      return false;
    }

    public static boolean isAllEmpty(final CharSequence... css) {
      return false;
    }

    public static boolean isAllLowerCase(final CharSequence cs) {
      return false;
    }

    public static boolean isAllUpperCase(final CharSequence cs) {
      return false;
    }

    public static boolean isAlpha(final CharSequence cs) {
      return false;
    }

    public static boolean isAlphanumeric(final CharSequence cs) {
      return false;
    }

    public static boolean isAlphanumericSpace(final CharSequence cs) {
      return false;
    }

    public static boolean isAlphaSpace(final CharSequence cs) {
      return false;
    }

    public static boolean isAnyBlank(final CharSequence... css) {
      return false;
    }

    public static boolean isAnyEmpty(final CharSequence... css) {
      return false;
    }

    public static boolean isAsciiPrintable(final CharSequence cs) {
      return false;
    }

    public static boolean isBlank(final CharSequence cs) {
      return false;
    }

    public static boolean isEmpty(final CharSequence cs) {
      return false;
    }

    public static boolean isMixedCase(final CharSequence cs) {
      return false;
    }

    public static boolean isNoneBlank(final CharSequence... css) {
      return false;
    }

    public static boolean isNoneEmpty(final CharSequence... css) {
      return false;
    }

    public static boolean isNotBlank(final CharSequence cs) {
      return false;
    }

    public static boolean isNotEmpty(final CharSequence cs) {
      return false;
    }

    public static boolean isNumeric(final CharSequence cs) {
      return false;
    }

    public static boolean isNumericSpace(final CharSequence cs) {
      return false;
    }

    public static boolean isWhitespace(final CharSequence cs) {
      return false;
    }

    public static String join(final boolean[] array, final char delimiter) {
      return null;
    }

    public static String join(final boolean[] array, final char delimiter, final int startIndex, final int endIndex) {
      return null;
    }

    public static String join(final byte[] array, final char delimiter) {
      return null;
    }

    public static String join(final byte[] array, final char delimiter, final int startIndex, final int endIndex) {
      return null;
    }

    public static String join(final char[] array, final char delimiter) {
      return null;
    }

    public static String join(final char[] array, final char delimiter, final int startIndex, final int endIndex) {
      return null;
    }

    public static String join(final double[] array, final char delimiter) {
      return null;
    }

    public static String join(final double[] array, final char delimiter, final int startIndex, final int endIndex) {
      return null;
    }

    public static String join(final float[] array, final char delimiter) {
      return null;
    }

    public static String join(final float[] array, final char delimiter, final int startIndex, final int endIndex) {
      return null;
    }

    public static String join(final int[] array, final char separator) {
      return null;
    }

    public static String join(final int[] array, final char delimiter, final int startIndex, final int endIndex) {
      return null;
    }

    public static String join(final Iterable<?> iterable, final char separator) {
      return null;
    }

    public static String join(final Iterable<?> iterable, final String separator) {
      return null;
    }

    public static String join(final Iterator<?> iterator, final char separator) {
      return null;
    }

    public static String join(final Iterator<?> iterator, final String separator) {
      return null;
    }

    public static String join(final List<?> list, final char separator, final int startIndex, final int endIndex) {
      return null;
    }

    public static String join(final List<?> list, final String separator, final int startIndex, final int endIndex) {
      return null;
    }

    public static String join(final long[] array, final char separator) {
      return null;
    }

    public static String join(final long[] array, final char delimiter, final int startIndex, final int endIndex) {
      return null;
    }

    public static String join(final Object[] array, final char delimiter) {
      return null;
    }

    public static String join(final Object[] array, final char delimiter, final int startIndex, final int endIndex) {
      return null;
    }

    public static String join(final Object[] array, final String delimiter) {
      return null;
    }

    public static String join(final Object[] array, String delimiter, final int startIndex, final int endIndex) {
      return null;
    }

    public static String join(final short[] array, final char delimiter) {
      return null;
    }

    public static String join(final short[] array, final char delimiter, final int startIndex, final int endIndex) {
      return null;
    }

    public static <T> String join(final T... elements) {
      return null;
    }

    public static String joinWith(final String delimiter, final Object... array) {
      return null;
    }

    public static int lastIndexOf(final CharSequence seq, final CharSequence searchSeq) {
      return 0;
    }

    public static int lastIndexOf(final CharSequence seq, final CharSequence searchSeq, final int startPos) {
      return 0;
    }

    public static int lastIndexOf(final CharSequence seq, final int searchChar) {
      return 0;
    }

    public static int lastIndexOf(final CharSequence seq, final int searchChar, final int startPos) {
      return 0;
    }

    public static int lastIndexOfAny(final CharSequence str, final CharSequence... searchStrs) {
      return 0;
    }

    public static int lastIndexOfIgnoreCase(final CharSequence str, final CharSequence searchStr) {
      return 0;
    }

    public static int lastIndexOfIgnoreCase(final CharSequence str, final CharSequence searchStr, int startPos) {
      return 0;
    }

    public static int lastOrdinalIndexOf(final CharSequence str, final CharSequence searchStr, final int ordinal) {
      return 0;
    }

    public static String left(final String str, final int len) {
      return null;
    }

    public static String leftPad(final String str, final int size) {
      return null;
    }

    public static String leftPad(final String str, final int size, final char padChar) {
      return null;
    }

    public static String leftPad(final String str, final int size, String padStr) {
      return null;
    }

    public static int length(final CharSequence cs) {
      return 0;
    }

    public static String lowerCase(final String str) {
      return null;
    }

    public static String lowerCase(final String str, final Locale locale) {
      return null;
    }

    public static String mid(final String str, int pos, final int len) {
      return null;
    }

    public static String normalizeSpace(final String str) {
      return null;
    }

    public static int ordinalIndexOf(final CharSequence str, final CharSequence searchStr, final int ordinal) {
      return 0;
    }

    public static String overlay(final String str, String overlay, int start, int end) {
      return null;
    }

    public static String prependIfMissing(final String str, final CharSequence prefix, final CharSequence... prefixes) {
      return null;
    }

    public static String prependIfMissingIgnoreCase(final String str, final CharSequence prefix, final CharSequence... prefixes) {
      return null;
    }

    public static String remove(final String str, final char remove) {
      return null;
    }

    public static String remove(final String str, final String remove) {
      return null;
    }

    public static String removeAll(final String text, final String regex) {
      return null;
    }

    public static String removeEnd(final String str, final String remove) {
      return null;
    }

    public static String removeEndIgnoreCase(final String str, final String remove) {
      return null;
    }

    public static String removeFirst(final String text, final String regex) {
      return null;
    }

    public static String removeIgnoreCase(final String str, final String remove) {
      return null;
    }

    public static String removePattern(final String source, final String regex) {
      return null;
    }

    public static String removeStart(final String str, final String remove) {
      return null;
    }

    public static String removeStartIgnoreCase(final String str, final String remove) {
      return null;
    }

    public static String repeat(final char ch, final int repeat) {
      return null;
    }

    public static String repeat(final String str, final int repeat) {
      return null;
    }

    public static String repeat(final String str, final String separator, final int repeat) {
      return null;
    }

    public static String replace(final String text, final String searchString, final String replacement) {
      return null;
    }

    public static String replace(final String text, final String searchString, final String replacement, final int max) {
      return null;
    }

    public static String replaceAll(final String text, final String regex, final String replacement) {
      return null;
    }

    public static String replaceChars(final String str, final char searchChar, final char replaceChar) {
      return null;
    }

    public static String replaceChars(final String str, final String searchChars, String replaceChars) {
      return null;
    }

    public static String replaceEach(final String text, final String[] searchList, final String[] replacementList) {
      return null;
    }

    public static String replaceEachRepeatedly(final String text, final String[] searchList, final String[] replacementList) {
      return null;
    }

    public static String replaceFirst(final String text, final String regex, final String replacement) {
      return null;
    }

   public static String replaceIgnoreCase(final String text, final String searchString, final String replacement) {
     return null;
   }

    public static String replaceIgnoreCase(final String text, final String searchString, final String replacement, final int max) {
      return null;
    }

    public static String replaceOnce(final String text, final String searchString, final String replacement) {
      return null;
    }

    public static String replaceOnceIgnoreCase(final String text, final String searchString, final String replacement) {
      return null;
    }

    public static String replacePattern(final String source, final String regex, final String replacement) {
      return null;
    }

    public static String reverse(final String str) {
      return null;
    }

    public static String reverseDelimited(final String str, final char separatorChar) {
      return null;
    }

    public static String right(final String str, final int len) {
      return null;
    }

    public static String rightPad(final String str, final int size) {
      return null;
    }

    public static String rightPad(final String str, final int size, final char padChar) {
      return null;
    }

    public static String rightPad(final String str, final int size, String padStr) {
      return null;
    }

    public static String rotate(final String str, final int shift) {
      return null;
    }

    public static String[] split(final String str) {
      return null;
    }

    public static String[] split(final String str, final char separatorChar) {
      return null;
    }

    public static String[] split(final String str, final String separatorChars) {
      return null;
    }

    public static String[] split(final String str, final String separatorChars, final int max) {
      return null;
    }

    public static String[] splitByCharacterType(final String str) {
      return null;
    }

    public static String[] splitByCharacterTypeCamelCase(final String str) {
      return null;
    }

    public static String[] splitByWholeSeparator(final String str, final String separator) {
      return null;
    }

    public static String[] splitByWholeSeparator( final String str, final String separator, final int max) {
      return null;
    }

    public static String[] splitByWholeSeparatorPreserveAllTokens(final String str, final String separator) {
      return null;
    }

    public static String[] splitByWholeSeparatorPreserveAllTokens(final String str, final String separator, final int max) {
      return null;
    }

    public static String[] splitPreserveAllTokens(final String str) {
      return null;
    }

    public static String[] splitPreserveAllTokens(final String str, final char separatorChar) {
      return null;
    }

    public static String[] splitPreserveAllTokens(final String str, final String separatorChars) {
      return null;
    }

    public static String[] splitPreserveAllTokens(final String str, final String separatorChars, final int max) {
      return null;
    }

    public static boolean startsWith(final CharSequence str, final CharSequence prefix) {
      return false;
    }

    public static boolean startsWithAny(final CharSequence sequence, final CharSequence... searchStrings) {
      return false;
    }

    public static boolean startsWithIgnoreCase(final CharSequence str, final CharSequence prefix) {
      return false;
    }

    public static String strip(final String str) {
      return null;
    }

    public static String strip(String str, final String stripChars) {
      return null;
    }

    public static String stripAccents(final String input) {
      return null;
    }

    public static String[] stripAll(final String... strs) {
      return null;
    }

    public static String[] stripAll(final String[] strs, final String stripChars) {
      return null;
    }

    public static String stripEnd(final String str, final String stripChars) {
      return null;
    }

    public static String stripStart(final String str, final String stripChars) {
      return null;
    }

    public static String stripToEmpty(final String str) {
      return null;
    }

    public static String stripToNull(String str) {
      return null;
    }

    public static String substring(final String str, int start) {
      return null;
    }

    public static String substring(final String str, int start, int end) {
      return null;
    }

    public static String substringAfter(final String str, final int separator) {
      return null;
    }

    public static String substringAfter(final String str, final String separator) {
      return null;
    }

    public static String substringAfterLast(final String str, final int separator) {
      return null;
    }

    public static String substringAfterLast(final String str, final String separator) {
      return null;
    }

    public static String substringBefore(final String str, final String separator) {
      return null;
    }

    public static String substringBeforeLast(final String str, final String separator) {
      return null;
    }

    public static String substringBetween(final String str, final String tag) {
      return null;
    }

    public static String substringBetween(final String str, final String open, final String close) {
      return null;
    }

    public static String[] substringsBetween(final String str, final String open, final String close) {
      return null;
    }

    public static String swapCase(final String str) {
      return null;
    }

    public static int[] toCodePoints(final CharSequence cs) {
      return null;
    }

    public static String toEncodedString(final byte[] bytes, final Charset charset) {
      return null;
    }

    public static String toRootLowerCase(final String source) {
      return null;
    }

    public static String toRootUpperCase(final String source) {
      return null;
    }

    public static String toString(final byte[] bytes, final String charsetName) throws UnsupportedEncodingException {
      return null;
    }

    public static String trim(final String str) {
      return null;
    }

    public static String trimToEmpty(final String str) {
      return null;
    }

    public static String trimToNull(final String str) {
      return null;
    }

    public static String truncate(final String str, final int maxWidth) {
      return null;
    }

    public static String truncate(final String str, final int offset, final int maxWidth) {
      return null;
    }

    public static String uncapitalize(final String str) {
      return null;
    }

    public static String unwrap(final String str, final char wrapChar) {
      return null;
    }

    public static String unwrap(final String str, final String wrapToken) {
      return null;
    }

    public static String upperCase(final String str) {
      return null;
    }

    public static String upperCase(final String str, final Locale locale) {
      return null;
    }

    public static String valueOf(final char[] value) {
      return null;
    }

    public static String wrap(final String str, final char wrapWith) {
      return null;
    }

    public static String wrap(final String str, final String wrapWith) {
      return null;
    }

    public static String wrapIfMissing(final String str, final char wrapWith) {
      return null;
    }

    public static String wrapIfMissing(final String str, final String wrapWith) {
      return null;
    }

    public StringUtils() {
    }

}