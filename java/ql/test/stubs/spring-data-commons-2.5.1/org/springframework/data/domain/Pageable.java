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

import java.util.Optional;


public interface Pageable {
	static Pageable unpaged() {
   return null;
 }

	static Pageable ofSize(int pageSize) {
   return null;
 }

	default boolean isPaged() {
   return false;
 }

	default boolean isUnpaged() {
   return false;
 }

	int getPageNumber();

	int getPageSize();

	long getOffset();

	Sort getSort();

	default Sort getSortOr(Sort sort) {
   return null;
 }

	Pageable next();

	Pageable previousOrFirst();

	Pageable first();

	Pageable withPage(int pageNumber);

	boolean hasPrevious();

	default Optional<Pageable> toOptional() {
   return null;
 }

}
