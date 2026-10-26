/*
 * Copyright 2002-2021 the original author or authors.
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

package org.springframework.ui;

import java.util.Collection;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.lang.Nullable;

public class ConcurrentModel extends ConcurrentHashMap<String, Object> implements Model {
	public ConcurrentModel() {
 }

	public ConcurrentModel(String attributeName, Object attributeValue) {
 }

	public ConcurrentModel(Object attributeValue) {
 }

	@Override
	public Object put(String key, @Nullable Object value) {
   return null;
 }

	@Override
	public void putAll(Map<? extends String, ?> map) {
 }

	@Override
	public ConcurrentModel addAttribute(String attributeName, @Nullable Object attributeValue) {
   return null;
 }

	@Override
	public ConcurrentModel addAttribute(Object attributeValue) {
   return null;
 }

	@Override
	public ConcurrentModel addAllAttributes(@Nullable Collection<?> attributeValues) {
   return null;
 }

	@Override
	public ConcurrentModel addAllAttributes(@Nullable Map<String, ?> attributes) {
   return null;
 }

	@Override
	public ConcurrentModel mergeAttributes(@Nullable Map<String, ?> attributes) {
   return null;
 }

	@Override
	public boolean containsAttribute(String attributeName) {
   return false;
 }

	@Override
	public Object getAttribute(String attributeName) {
   return null;
 }

	@Override
	public Map<String, Object> asMap() {
   return null;
 }

}
