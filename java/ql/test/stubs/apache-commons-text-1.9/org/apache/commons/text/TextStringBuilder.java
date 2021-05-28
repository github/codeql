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

import java.io.IOException;
import java.io.Reader;
import java.io.Serializable;
import java.io.Writer;
import java.nio.CharBuffer;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.text.matcher.StringMatcher;

public class TextStringBuilder implements CharSequence, Appendable, Serializable, Builder<String> {
    public static TextStringBuilder wrap(final char[] initialBuffer) {
      return null;
    }

    public static TextStringBuilder wrap(final char[] initialBuffer, final int length) {
      return null;
    }

    public TextStringBuilder() {
    }

    public TextStringBuilder(final CharSequence seq) {
    }

    public TextStringBuilder(final int initialCapacity) {
    }

    public TextStringBuilder(final String str) {
    }

    public TextStringBuilder append(final boolean value) {
      return null;
    }

    @Override
    public TextStringBuilder append(final char ch) {
      return null;
    }

    public TextStringBuilder append(final char[] chars) {
      return null;
    }

    public TextStringBuilder append(final char[] chars, final int startIndex, final int length) {
      return null;
    }

    public TextStringBuilder append(final CharBuffer str) {
      return null;
    }

    public TextStringBuilder append(final CharBuffer buf, final int startIndex, final int length) {
      return null;
    }

    @Override
    public TextStringBuilder append(final CharSequence seq) {
      return null;
    }

    @Override
    public TextStringBuilder append(final CharSequence seq, final int startIndex, final int endIndex) {
      return null;
    }

    public TextStringBuilder append(final double value) {
      return null;
    }

    public TextStringBuilder append(final float value) {
      return null;
    }

    public TextStringBuilder append(final int value) {
      return null;
    }

    public TextStringBuilder append(final long value) {
      return null;
    }

    public TextStringBuilder append(final Object obj) {
      return null;
    }

    public TextStringBuilder append(final String str) {
      return null;
    }

    public TextStringBuilder append(final String str, final int startIndex, final int length) {
      return null;
    }

    public TextStringBuilder append(final String format, final Object... objs) {
      return null;
    }

    public TextStringBuilder append(final StringBuffer str) {
      return null;
    }

    public TextStringBuilder append(final StringBuffer str, final int startIndex, final int length) {
      return null;
    }

    public TextStringBuilder append(final StringBuilder str) {
      return null;
    }

    public TextStringBuilder append(final StringBuilder str, final int startIndex, final int length) {
      return null;
    }

    public TextStringBuilder append(final TextStringBuilder str) {
      return null;
    }

    public TextStringBuilder append(final TextStringBuilder str, final int startIndex, final int length) {
      return null;
    }

    public TextStringBuilder appendAll(final Iterable<?> iterable) {
      return null;
    }

    public TextStringBuilder appendAll(final Iterator<?> it) {
      return null;
    }

    public <T> TextStringBuilder appendAll(@SuppressWarnings("unchecked") final T... array) {
      return null;
    }

    public TextStringBuilder appendFixedWidthPadLeft(final int value, final int width, final char padChar) {
      return null;
    }

    public TextStringBuilder appendFixedWidthPadLeft(final Object obj, final int width, final char padChar) {
      return null;
    }

    public TextStringBuilder appendFixedWidthPadRight(final int value, final int width, final char padChar) {
      return null;
    }

    public TextStringBuilder appendFixedWidthPadRight(final Object obj, final int width, final char padChar) {
      return null;
    }

    public TextStringBuilder appendln(final boolean value) {
      return null;
    }

    public TextStringBuilder appendln(final char ch) {
      return null;
    }

    public TextStringBuilder appendln(final char[] chars) {
      return null;
    }

    public TextStringBuilder appendln(final char[] chars, final int startIndex, final int length) {
      return null;
    }

    public TextStringBuilder appendln(final double value) {
      return null;
    }

    public TextStringBuilder appendln(final float value) {
      return null;
    }

    public TextStringBuilder appendln(final int value) {
      return null;
    }

    public TextStringBuilder appendln(final long value) {
      return null;
    }

    public TextStringBuilder appendln(final Object obj) {
      return null;
    }

    public TextStringBuilder appendln(final String str) {
      return null;
    }

    public TextStringBuilder appendln(final String str, final int startIndex, final int length) {
      return null;
    }

    public TextStringBuilder appendln(final String format, final Object... objs) {
      return null;
    }

    public TextStringBuilder appendln(final StringBuffer str) {
      return null;
    }

    public TextStringBuilder appendln(final StringBuffer str, final int startIndex, final int length) {
      return null;
    }

    public TextStringBuilder appendln(final StringBuilder str) {
      return null;
    }

    public TextStringBuilder appendln(final StringBuilder str, final int startIndex, final int length) {
      return null;
    }

    public TextStringBuilder appendln(final TextStringBuilder str) {
      return null;
    }

    public TextStringBuilder appendln(final TextStringBuilder str, final int startIndex, final int length) {
      return null;
    }

    public TextStringBuilder appendNewLine() {
      return null;
    }

    public TextStringBuilder appendNull() {
      return null;
    }

    public TextStringBuilder appendPadding(final int length, final char padChar) {
      return null;
    }

    public TextStringBuilder appendSeparator(final char separator) {
      return null;
    }

    public TextStringBuilder appendSeparator(final char standard, final char defaultIfEmpty) {
      return null;
    }

    public TextStringBuilder appendSeparator(final char separator, final int loopIndex) {
      return null;
    }

    public TextStringBuilder appendSeparator(final String separator) {
      return null;
    }

    public TextStringBuilder appendSeparator(final String separator, final int loopIndex) {
      return null;
    }

    public TextStringBuilder appendSeparator(final String standard, final String defaultIfEmpty) {
      return null;
    }

    public void appendTo(final Appendable appendable) throws IOException {
    }

    public TextStringBuilder appendWithSeparators(final Iterable<?> iterable, final String separator) {
      return null;
    }

    public TextStringBuilder appendWithSeparators(final Iterator<?> it, final String separator) {
      return null;
    }

    public TextStringBuilder appendWithSeparators(final Object[] array, final String separator) {
      return null;
    }

    public Reader asReader() {
      return null;
    }

    public StringTokenizer asTokenizer() {
      return null;
    }

    public Writer asWriter() {
      return null;
    }

    @Override
    public String build() {
      return null;
    }

    public int capacity() {
      return 0;
    }

    @Override
    public char charAt(final int index) {
      return 0;
    }

    public TextStringBuilder clear() {
      return null;
    }

    public boolean contains(final char ch) {
      return false;
    }

    public boolean contains(final String str) {
      return false;
    }

    public boolean contains(final StringMatcher matcher) {
      return false;
    }

    public TextStringBuilder delete(final int startIndex, final int endIndex) {
      return null;
    }

    public TextStringBuilder deleteAll(final char ch) {
      return null;
    }

    public TextStringBuilder deleteAll(final String str) {
      return null;
    }

    public TextStringBuilder deleteAll(final StringMatcher matcher) {
      return null;
    }

    public TextStringBuilder deleteCharAt(final int index) {
      return null;
    }

    public TextStringBuilder deleteFirst(final char ch) {
      return null;
    }

    public TextStringBuilder deleteFirst(final String str) {
      return null;
    }

    public TextStringBuilder deleteFirst(final StringMatcher matcher) {
      return null;
    }

    public char drainChar(final int index) {
      return 0;
    }

    public int drainChars(final int startIndex, final int endIndex, final char[] target, final int targetIndex) {
      return 0;
    }

    public boolean endsWith(final String str) {
      return false;
    }

    public TextStringBuilder ensureCapacity(final int capacity) {
      return null;
    }

    @Override
    public boolean equals(final Object obj) {
      return false;
    }

    public boolean equals(final TextStringBuilder other) {
      return false;
    }

    public boolean equalsIgnoreCase(final TextStringBuilder other) {
      return false;
    }

    public char[] getChars(char[] target) {
      return null;
    }

    public void getChars(final int startIndex, final int endIndex, final char[] target, final int targetIndex) {
    }

    public String getNewLineText() {
      return null;
    }

    public String getNullText() {
      return null;
    }

    @Override
    public int hashCode() {
      return 0;
    }

    public int indexOf(final char ch) {
      return 0;
    }

    public int indexOf(final char ch, int startIndex) {
      return 0;
    }

    public int indexOf(final String str) {
      return 0;
    }

    public int indexOf(final String str, int startIndex) {
      return 0;
    }

    public int indexOf(final StringMatcher matcher) {
      return 0;
    }

    public int indexOf(final StringMatcher matcher, int startIndex) {
      return 0;
    }

    public TextStringBuilder insert(final int index, final boolean value) {
      return null;
    }

    public TextStringBuilder insert(final int index, final char value) {
      return null;
    }

    public TextStringBuilder insert(final int index, final char[] chars) {
      return null;
    }

    public TextStringBuilder insert(final int index, final char[] chars, final int offset, final int length) {
      return null;
    }

    public TextStringBuilder insert(final int index, final double value) {
      return null;
    }

    public TextStringBuilder insert(final int index, final float value) {
      return null;
    }

    public TextStringBuilder insert(final int index, final int value) {
      return null;
    }

    public TextStringBuilder insert(final int index, final long value) {
      return null;
    }

    public TextStringBuilder insert(final int index, final Object obj) {
      return null;
    }

    public TextStringBuilder insert(final int index, String str) {
      return null;
    }

    public boolean isEmpty() {
      return false;
    }

    public boolean isNotEmpty() {
      return false;
    }

    public boolean isReallocated() {
      return false;
    }

    public int lastIndexOf(final char ch) {
      return 0;
    }

    public int lastIndexOf(final char ch, int startIndex) {
      return 0;
    }

    public int lastIndexOf(final String str) {
      return 0;
    }

    public int lastIndexOf(final String str, int startIndex) {
      return 0;
    }

    public int lastIndexOf(final StringMatcher matcher) {
      return 0;
    }

    public int lastIndexOf(final StringMatcher matcher, int startIndex) {
      return 0;
    }

    public String leftString(final int length) {
      return null;
    }

    @Override
    public int length() {
      return 0;
    }

    public String midString(int index, final int length) {
      return null;
    }

    public TextStringBuilder minimizeCapacity() {
      return null;
    }

    public int readFrom(final CharBuffer charBuffer) throws IOException {
      return 0;
    }

    public int readFrom(final Readable readable) throws IOException {
      return 0;
    }

    public int readFrom(final Reader reader) throws IOException {
      return 0;
    }

    public int readFrom(final Reader reader, final int count) throws IOException {
      return 0;
    }

    public TextStringBuilder replace(final int startIndex, int endIndex, final String replaceStr) {
      return null;
    }

    public TextStringBuilder replace(final StringMatcher matcher, final String replaceStr, final int startIndex,
        int endIndex, final int replaceCount) {
      return null;
    }

    public TextStringBuilder replaceAll(final char search, final char replace) {
      return null;
    }

    public TextStringBuilder replaceAll(final String searchStr, final String replaceStr) {
      return null;
    }

    public TextStringBuilder replaceAll(final StringMatcher matcher, final String replaceStr) {
      return null;
    }

    public TextStringBuilder replaceFirst(final char search, final char replace) {
      return null;
    }

    public TextStringBuilder replaceFirst(final String searchStr, final String replaceStr) {
      return null;
    }

    public TextStringBuilder replaceFirst(final StringMatcher matcher, final String replaceStr) {
      return null;
    }

    public TextStringBuilder reverse() {
      return null;
    }

    public String rightString(final int length) {
      return null;
    }

    public TextStringBuilder set(final CharSequence str) {
      return null;
    }

    public TextStringBuilder setCharAt(final int index, final char ch) {
      return null;
    }

    public TextStringBuilder setLength(final int length) {
      return null;
    }

    public TextStringBuilder setNewLineText(final String newLine) {
      return null;
    }

    public TextStringBuilder setNullText(String nullText) {
      return null;
    }

    public int size() {
      return 0;
    }

    public boolean startsWith(final String str) {
      return false;
    }

    @Override
    public CharSequence subSequence(final int startIndex, final int endIndex) {
      return null;
    }

    public String substring(final int start) {
      return null;
    }

    public String substring(final int startIndex, int endIndex) {
      return null;
    }

    public char[] toCharArray() {
      return null;
    }

    public char[] toCharArray(final int startIndex, int endIndex) {
      return null;
    }

    @Override
    public String toString() {
      return null;
    }

    public StringBuffer toStringBuffer() {
      return null;
    }

    public StringBuilder toStringBuilder() {
      return null;
    }

    public TextStringBuilder trim() {
      return null;
    }

}
