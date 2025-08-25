/*
 * Copyright 2002-2019 the original author or authors.
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
import org.springframework.lang.Nullable;

public class PropertyValue implements Serializable {
	public PropertyValue(String name, @Nullable Object value) {}

	public PropertyValue(PropertyValue original) {}

	public PropertyValue(PropertyValue original, @Nullable Object newValue) {}

	public String getName() {
		return null;
	}

	public Object getValue() {
		return null;
	}

	public PropertyValue getOriginalPropertyValue() {
		return null;
	}

	public void setOptional(boolean optional) {}

	public boolean isOptional() {
		return false;
	}

	public synchronized boolean isConverted() {
		return false;
	}

	public synchronized void setConvertedValue(@Nullable Object value) {}

	public synchronized Object getConvertedValue() {
		return null;
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
