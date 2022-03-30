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
import java.util.Map;

import org.springframework.lang.Nullable;

public interface Model {
	Model addAttribute(String attributeName, @Nullable Object attributeValue);

	Model addAttribute(Object attributeValue);

	Model addAllAttributes(Collection<?> attributeValues);

	Model addAllAttributes(Map<String, ?> attributes);

	Model mergeAttributes(Map<String, ?> attributes);

	boolean containsAttribute(String attributeName);

	Object getAttribute(String attributeName);

	Map<String, Object> asMap();

}
