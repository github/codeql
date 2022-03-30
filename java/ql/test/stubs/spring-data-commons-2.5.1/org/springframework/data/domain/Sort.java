/*
 * Copyright 2008-2021 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.springframework.data.domain;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collectors;

import org.springframework.data.util.Streamable;
import org.springframework.data.util.MethodInvocationRecorder.Recorded;
import org.springframework.lang.Nullable;

public class Sort implements Streamable<org.springframework.data.domain.Sort.Order>, Serializable {
	public static Sort by(String... properties) {
   return null;
 }

	public static Sort by(List<Order> orders) {
   return null;
 }

	public static Sort by(Order... orders) {
   return null;
 }

	public static Sort by(Direction direction, String... properties) {
   return null;
 }

	public static <T> TypedSort<T> sort(Class<T> type) {
   return null;
 }

	public static Sort unsorted() {
   return null;
 }

	public Sort descending() {
   return null;
 }

	public Sort ascending() {
   return null;
 }

	public boolean isSorted() {
   return false;
 }

	public boolean isUnsorted() {
   return false;
 }

	public Sort and(Sort sort) {
   return null;
 }

	public Order getOrderFor(String property) {
   return null;
 }

	public Iterator<Order> iterator() {
   return null;
 }

	@Override
	public boolean equals(@Nullable Object obj) {
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

	public static class Order implements Serializable {
		public Order(@Nullable Direction direction, String property) {
  }

		public Order(@Nullable Direction direction, String property, NullHandling nullHandlingHint) {
  }

		public static Order by(String property) {
    return null;
  }

		public static Order asc(String property) {
    return null;
  }

		public static Order desc(String property) {
    return null;
  }

		public Direction getDirection() {
    return null;
  }

		public String getProperty() {
    return null;
  }

		public boolean isAscending() {
    return false;
  }

		public boolean isDescending() {
    return false;
  }

		public boolean isIgnoreCase() {
    return false;
  }

		public Order with(Direction direction) {
    return null;
  }

		public Order withProperty(String property) {
    return null;
  }

		public Sort withProperties(String... properties) {
    return null;
  }

		public Order ignoreCase() {
    return null;
  }

		public Order with(NullHandling nullHandling) {
    return null;
  }

		public Order nullsFirst() {
    return null;
  }

		public Order nullsLast() {
    return null;
  }

		public Order nullsNative() {
    return null;
  }

		public NullHandling getNullHandling() {
    return null;
  }

		@Override
		public int hashCode() {
    return 0;
  }

		@Override
		public boolean equals(@Nullable Object obj) {
    return false;
  }

		@Override
		public String toString() {
    return null;
  }

 }
	public static class TypedSort<T> extends Sort {
		public <S> TypedSort<S> by(Function<T, S> property) {
    return null;
  }

		public <S> TypedSort<S> by(Recorded.ToCollectionConverter<T, S> collectionProperty) {
    return null;
  }

		public <S> TypedSort<S> by(Recorded.ToMapConverter<T, S> mapProperty) {
    return null;
  }

		@Override
		public Sort ascending() {
    return null;
  }

		@Override
		public Sort descending() {
    return null;
  }

		@Override
		public Iterator<Order> iterator() {
    return null;
  }

		@Override
		public String toString() {
    return null;
  }

 }

 public static enum Direction {
   ASC, DESC;

   public boolean isAscending() { return true; }
   public boolean isDescending() { return true; }
   public static Direction fromString(String value) { return null; }
   public static Optional<Direction> fromOptionalString(String value) { return null; }
 }

 public static enum NullHandling { NATIVE, NULLS_FIRST, NULLS_LAST; }
}
