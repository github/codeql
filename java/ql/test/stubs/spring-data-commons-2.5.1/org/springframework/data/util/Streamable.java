/*
 * Copyright 2016-2021 the original author or authors.
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
package org.springframework.data.util;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.function.BiConsumer;
import java.util.function.BinaryOperator;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.function.Supplier;
import java.util.stream.Collector;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import java.util.stream.StreamSupport;


public interface Streamable<T> extends Iterable<T>, Supplier<Stream<T>> {
	static <T> Streamable<T> empty() {
   return null;
 }

	static <T> Streamable<T> of(T... t) {
   return null;
 }

	static <T> Streamable<T> of(Iterable<T> iterable) {
   return null;
 }

	static <T> Streamable<T> of(Supplier<? extends Stream<T>> supplier) {
   return null;
 }

	default Stream<T> stream() {
   return null;
 }

	default <R> Streamable<R> map(Function<? super T, ? extends R> mapper) {
   return null;
 }

	default <R> Streamable<R> flatMap(Function<? super T, ? extends Stream<? extends R>> mapper) {
   return null;
 }

	default Streamable<T> filter(Predicate<? super T> predicate) {
   return null;
 }

	default boolean isEmpty() {
   return false;
 }

	default Streamable<T> and(Supplier<? extends Stream<? extends T>> stream) {
   return null;
 }

	default Streamable<T> and(T... others) {
   return null;
 }

	default Streamable<T> and(Iterable<? extends T> iterable) {
   return null;
 }

	default Streamable<T> and(Streamable<? extends T> streamable) {
   return null;
 }

	default List<T> toList() {
   return null;
 }

	default Set<T> toSet() {
   return null;
 }

	default Stream<T> get() {
   return null;
 }

	public static <S> Collector<S, ?, Streamable<S>> toStreamable() {
   return null;
 }

	public static <S, T extends Iterable<S>> Collector<S, ?, Streamable<S>> toStreamable(
			Collector<S, ?, T> intermediate) {
   return null;
 }

}
