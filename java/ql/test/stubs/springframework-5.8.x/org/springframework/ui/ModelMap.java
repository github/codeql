/*
 * Copyright 2002-2019 the original author or authors.
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
import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.lang.Nullable;

public class ModelMap extends LinkedHashMap<String, Object> {
	public ModelMap() {
 }

	public ModelMap(String attributeName, @Nullable Object attributeValue) {
 }

	public ModelMap(Object attributeValue) {
 }

	public ModelMap addAttribute(String attributeName, @Nullable Object attributeValue) {
   return null;
 }

	public ModelMap addAttribute(Object attributeValue) {
   return null;
 }

	public ModelMap addAllAttributes(@Nullable Collection<?> attributeValues) {
   return null;
 }

	public ModelMap addAllAttributes(@Nullable Map<String, ?> attributes) {
   return null;
 }

	public ModelMap mergeAttributes(@Nullable Map<String, ?> attributes) {
   return null;
 }

	public boolean containsAttribute(String attributeName) {
   return false;
 }

	public Object getAttribute(String attributeName) {
   return null;
 }

}
