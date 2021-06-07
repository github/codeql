/*
 * Copyright 2002-2020 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 *
 * https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License
 * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing permissions and limitations under
 * the License.
 */

package org.springframework.beans;

import java.io.Serializable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Spliterator;
import java.util.stream.Stream;
import org.springframework.lang.Nullable;

public class MutablePropertyValues implements PropertyValues, Serializable {
	public MutablePropertyValues() {}

	public MutablePropertyValues(@Nullable PropertyValues original) {}

	public MutablePropertyValues(@Nullable Map<?, ?> original) {}

	public MutablePropertyValues(@Nullable List<PropertyValue> propertyValueList) {}

	public List<PropertyValue> getPropertyValueList() {
		return null;
	}

	public int size() {
		return 0;
	}

	public MutablePropertyValues addPropertyValues(@Nullable PropertyValues other) {
		return null;
	}

	public MutablePropertyValues addPropertyValues(@Nullable Map<?, ?> other) {
		return null;
	}

	public MutablePropertyValues addPropertyValue(PropertyValue pv) {
		return null;
	}

	public void addPropertyValue(String propertyName, Object propertyValue) {}

	public MutablePropertyValues add(String propertyName, @Nullable Object propertyValue) {
		return null;
	}

	public void setPropertyValueAt(PropertyValue pv, int i) {}

	public void removePropertyValue(PropertyValue pv) {}

	public void removePropertyValue(String propertyName) {}

	@Override
	public Iterator<PropertyValue> iterator() {
		return null;
	}

	@Override
	public Spliterator<PropertyValue> spliterator() {
		return null;
	}

	@Override
	public Stream<PropertyValue> stream() {
		return null;
	}

	@Override
	public PropertyValue[] getPropertyValues() {
		return null;
	}

	@Override
	public PropertyValue getPropertyValue(String propertyName) {
		return null;
	}

	public Object get(String propertyName) {
		return null;
	}

	@Override
	public PropertyValues changesSince(PropertyValues old) {
		return null;
	}

	@Override
	public boolean contains(String propertyName) {
		return false;
	}

	@Override
	public boolean isEmpty() {
		return false;
	}

	public void registerProcessedProperty(String propertyName) {}

	public void clearProcessedProperty(String propertyName) {}

	public void setConverted() {}

	public boolean isConverted() {
		return false;
	}

	@Override
	public boolean equals(@Nullable Object other) {
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

}
