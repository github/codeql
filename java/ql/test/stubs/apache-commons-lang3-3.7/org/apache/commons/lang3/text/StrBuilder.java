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

import org.apache.commons.lang3.builder.Builder;

import java.io.IOException;
import java.io.Reader;
import java.io.Serializable;
import java.io.Writer;
import java.nio.CharBuffer;
import java.util.Iterator;
import java.util.List;


public class StrBuilder implements CharSequence, Appendable, Serializable, Builder<String> {
    public StrBuilder() {
    }

    public StrBuilder(int initialCapacity) {
    }

    public StrBuilder(final String str) {
    }

    public String getNewLineText() {
      return null;
    }

    public StrBuilder setNewLineText(final String newLine) {
      return null;
    }

    public String getNullText() {
      return null;
    }

    public StrBuilder setNullText(String nullText) {
      return null;
    }

    @Override
    public int length() {
      return 0;
    }

    public StrBuilder setLength(final int length) {
      return null;
    }

    public int capacity() {
      return 0;
    }

    public StrBuilder ensureCapacity(final int capacity) {
      return null;
    }

    public StrBuilder minimizeCapacity() {
      return null;
    }

    public int size() {
      return 0;
    }

    public boolean isEmpty() {
      return false;
    }

    public StrBuilder clear() {
      return null;
    }

    @Override
    public char charAt(final int index) {
      return 0;
    }

    public StrBuilder setCharAt(final int index, final char ch) {
      return null;
    }

    public StrBuilder deleteCharAt(final int index) {
      return null;
    }

    public char[] toCharArray() {
      return null;
    }

    public char[] toCharArray(final int startIndex, int endIndex) {
      return null;
    }

    public char[] getChars(char[] destination) {
      return null;
    }

    public void getChars(final int startIndex, final int endIndex, final char destination[], final int destinationIndex) {
    }

    public int readFrom(final Readable readable) throws IOException {
      return 0;
    }

    public StrBuilder appendNewLine() {
      return null;
    }

    public StrBuilder appendNull() {
      return null;
    }

    public StrBuilder append(final Object obj) {
      return null;
    }

    @Override
    public StrBuilder append(final CharSequence seq) {
      return null;
    }

    @Override
    public StrBuilder append(final CharSequence seq, final int startIndex, final int length) {
      return null;
    }

    public StrBuilder append(final String str) {
      return null;
    }

    public StrBuilder append(final String str, final int startIndex, final int length) {
      return null;
    }

    public StrBuilder append(final String format, final Object... objs) {
      return null;
    }

    public StrBuilder append(final CharBuffer buf) {
      return null;
    }

    public StrBuilder append(final CharBuffer buf, final int startIndex, final int length) {
      return null;
    }

    public StrBuilder append(final StringBuffer str) {
      return null;
    }

    public StrBuilder append(final StringBuffer str, final int startIndex, final int length) {
      return null;
    }

    public StrBuilder append(final StringBuilder str) {
      return null;
    }

    public StrBuilder append(final StringBuilder str, final int startIndex, final int length) {
      return null;
    }

    public StrBuilder append(final StrBuilder str) {
      return null;
    }

    public StrBuilder append(final StrBuilder str, final int startIndex, final int length) {
      return null;
    }

    public StrBuilder append(final char[] chars) {
      return null;
    }

    public StrBuilder append(final char[] chars, final int startIndex, final int length) {
      return null;
    }

    public StrBuilder append(final boolean value) {
      return null;
    }

    @Override
    public StrBuilder append(final char ch) {
      return null;
    }

    public StrBuilder append(final int value) {
      return null;
    }

    public StrBuilder append(final long value) {
      return null;
    }

    public StrBuilder append(final float value) {
      return null;
    }

    public StrBuilder append(final double value) {
      return null;
    }

    public StrBuilder appendln(final Object obj) {
      return null;
    }

    public StrBuilder appendln(final String str) {
      return null;
    }

    public StrBuilder appendln(final String str, final int startIndex, final int length) {
      return null;
    }

    public StrBuilder appendln(final String format, final Object... objs) {
      return null;
    }

    public StrBuilder appendln(final StringBuffer str) {
      return null;
    }

    public StrBuilder appendln(final StringBuilder str) {
      return null;
    }

    public StrBuilder appendln(final StringBuilder str, final int startIndex, final int length) {
      return null;
    }

    public StrBuilder appendln(final StringBuffer str, final int startIndex, final int length) {
      return null;
    }

    public StrBuilder appendln(final StrBuilder str) {
      return null;
    }

    public StrBuilder appendln(final StrBuilder str, final int startIndex, final int length) {
      return null;
    }

    public StrBuilder appendln(final char[] chars) {
      return null;
    }

    public StrBuilder appendln(final char[] chars, final int startIndex, final int length) {
      return null;
    }

    public StrBuilder appendln(final boolean value) {
      return null;
    }

    public StrBuilder appendln(final char ch) {
      return null;
    }

    public StrBuilder appendln(final int value) {
      return null;
    }

    public StrBuilder appendln(final long value) {
      return null;
    }

    public StrBuilder appendln(final float value) {
      return null;
    }

    public StrBuilder appendln(final double value) {
      return null;
    }

    public <T> StrBuilder appendAll(final T... array) {
      return null;
    }

    public StrBuilder appendAll(final Iterable<?> iterable) {
      return null;
    }

    public StrBuilder appendAll(final Iterator<?> it) {
      return null;
    }

    public StrBuilder appendWithSeparators(final Object[] array, final String separator) {
      return null;
    }

    public StrBuilder appendWithSeparators(final Iterable<?> iterable, final String separator) {
      return null;
    }

    public StrBuilder appendWithSeparators(final Iterator<?> it, final String separator) {
      return null;
    }

    public StrBuilder appendSeparator(final String separator) {
      return null;
    }

    public StrBuilder appendSeparator(final String standard, final String defaultIfEmpty) {
      return null;
    }

    public StrBuilder appendSeparator(final char separator) {
      return null;
    }

    public StrBuilder appendSeparator(final char standard, final char defaultIfEmpty) {
      return null;
    }

    public StrBuilder appendSeparator(final String separator, final int loopIndex) {
      return null;
    }

    public StrBuilder appendSeparator(final char separator, final int loopIndex) {
      return null;
    }

    public StrBuilder appendPadding(final int length, final char padChar) {
      return null;
    }

    public StrBuilder appendFixedWidthPadLeft(final Object obj, final int width, final char padChar) {
      return null;
    }

    public StrBuilder appendFixedWidthPadLeft(final int value, final int width, final char padChar) {
      return null;
    }

    public StrBuilder appendFixedWidthPadRight(final Object obj, final int width, final char padChar) {
      return null;
    }

    public StrBuilder appendFixedWidthPadRight(final int value, final int width, final char padChar) {
      return null;
    }

    public StrBuilder insert(final int index, final Object obj) {
      return null;
    }

    public StrBuilder insert(final int index, String str) {
      return null;
    }

    public StrBuilder insert(final int index, final char chars[]) {
      return null;
    }

    public StrBuilder insert(final int index, final char chars[], final int offset, final int length) {
      return null;
    }

    public StrBuilder insert(int index, final boolean value) {
      return null;
    }

    public StrBuilder insert(final int index, final char value) {
      return null;
    }

    public StrBuilder insert(final int index, final int value) {
      return null;
    }

    public StrBuilder insert(final int index, final long value) {
      return null;
    }

    public StrBuilder insert(final int index, final float value) {
      return null;
    }

    public StrBuilder insert(final int index, final double value) {
      return null;
    }

    public StrBuilder delete(final int startIndex, int endIndex) {
      return null;
    }

    public StrBuilder deleteAll(final char ch) {
      return null;
    }

    public StrBuilder deleteFirst(final char ch) {
      return null;
    }

    public StrBuilder deleteAll(final String str) {
      return null;
    }

    public StrBuilder deleteFirst(final String str) {
      return null;
    }

    public StrBuilder deleteAll(final StrMatcher matcher) {
      return null;
    }

    public StrBuilder deleteFirst(final StrMatcher matcher) {
      return null;
    }

    public StrBuilder replace(final int startIndex, int endIndex, final String replaceStr) {
      return null;
    }

    public StrBuilder replaceAll(final char search, final char replace) {
      return null;
    }

    public StrBuilder replaceFirst(final char search, final char replace) {
      return null;
    }

    public StrBuilder replaceAll(final String searchStr, final String replaceStr) {
      return null;
    }

    public StrBuilder replaceFirst(final String searchStr, final String replaceStr) {
      return null;
    }

    public StrBuilder replaceAll(final StrMatcher matcher, final String replaceStr) {
      return null;
    }

    public StrBuilder replaceFirst(final StrMatcher matcher, final String replaceStr) {
      return null;
    }

    public StrBuilder replace(
            final StrMatcher matcher, final String replaceStr,
            final int startIndex, int endIndex, final int replaceCount) {
      return null;
    }

    public StrBuilder reverse() {
      return null;
    }

    public StrBuilder trim() {
      return null;
    }

    public boolean startsWith(final String str) {
      return false;
    }

    public boolean endsWith(final String str) {
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

    public String leftString(final int length) {
      return null;
    }

    public String rightString(final int length) {
      return null;
    }

    public String midString(int index, final int length) {
      return null;
    }

    public boolean contains(final char ch) {
      return false;
    }

    public boolean contains(final String str) {
      return false;
    }

    public boolean contains(final StrMatcher matcher) {
      return false;
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

    public int indexOf(final StrMatcher matcher) {
      return 0;
    }

    public int indexOf(final StrMatcher matcher, int startIndex) {
      return 0;
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

    public int lastIndexOf(final StrMatcher matcher) {
      return 0;
    }

    public int lastIndexOf(final StrMatcher matcher, int startIndex) {
      return 0;
    }

    public StrTokenizer asTokenizer() {
      return null;
    }

    public Reader asReader() {
      return null;
    }

    public Writer asWriter() {
      return null;
    }

    public void appendTo(final Appendable appendable) throws IOException {
    }

    public boolean equalsIgnoreCase(final StrBuilder other) {
      return false;
    }

    public boolean equals(final StrBuilder other) {
      return false;
    }

    @Override
    public boolean equals(final Object obj) {
      return false;
    }

    @Override
    public int hashCode() {
      return 0;
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

    @Override
    public String build() {
      return null;
    }

}
