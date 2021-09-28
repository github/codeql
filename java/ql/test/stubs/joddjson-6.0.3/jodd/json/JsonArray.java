// Copyright (c) 2003-present, Jodd Team (http://jodd.org)
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice,
// this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright
// notice, this list of conditions and the following disclaimer in the
// documentation and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

package jodd.json;

import java.util.Iterator;
import java.util.List;
import java.util.Map;

/**
 * Representation of JSON array.
 * @see JsonObject
 */
public class JsonArray implements Iterable<Object> {

	/**
	 * Creates an empty instance.
	 */
	public JsonArray() {
	}

	/**
	 * Creates an instance from a List. The List is not copied.
	 */
	public JsonArray(final List list) {
	}

	// ---------------------------------------------------------------- get

	/**
	 * Returns the string at position {@code pos} in the array.
	 */
	public String getString(final int pos) {
		return null;
	}

	/**
	 * Returns the integer at position {@code pos} in the array.
	 */
	public Integer getInteger(final int pos) {
		return null;
	}

	/**
	 * Returns the long at position {@code pos} in the array.
	 */
	public Long getLong(final int pos) {
		return null;
	}

	/**
	 * Returns the double at position {@code pos} in the array.
	 */
	public Double getDouble(final int pos) {
		return null;
	}

	/**
	 * Returns the Float at position {@code pos} in the array.
	 */
	public Float getFloat(final int pos) {
		return null;
	}

	/**
	 * Returns the boolean at position {@code pos} in the array.
	 */
	public Boolean getBoolean(final int pos) {
		return null;
	}

	/**
	 * Returns the JsonObject at position {@code pos} in the array.
	 */
	public JsonObject getJsonObject(final int pos) {
		return null;
	}

	/**
	 * Returns the JsonArray at position {@code pos} in the array.
	 */
	public JsonArray getJsonArray(final int pos) {
		return null;
	}

	/**
	 * Returns the byte[] at position {@code pos} in the array.
	 * <p>
	 * JSON itself has no notion of a binary, so this method assumes there is a String value and
	 * it contains a Base64 encoded binary, which it decodes if found and returns.
	 */
	public byte[] getBinary(final int pos) {
		return null;
	}

	/**
	 * Returns the object value at position {@code pos} in the array.
	 */
	public Object getValue(final int pos) {
		return null;
	}

	/**
	 * Returns {@code true} if there is a {@code null} value at given index.
	 */
	public boolean hasNull(final int pos) {
		return false;
	}

	/**
	 * Adds an enum to the JSON array.
	 * <p>
	 * JSON has no concept of encoding Enums, so the Enum will be converted to a String using the {@link java.lang.Enum#name}
	 * method and the value added as a String.
	 */
	public JsonArray add(final Enum value) {
		return null;
	}

	/**
	 * Adds a {@code CharSequence} to the JSON array.
	 */
	public JsonArray add(final CharSequence value) {
		return null;
	}

	/**
	 * Adds a string to the JSON array.
	 */
	public JsonArray add(final String value) {
		return null;
	}

	/**
	 * Adds an integer to the JSON array.
	 */
	public JsonArray add(final Integer value) {
		return null;
	}

	/**
	 * Adds a long to the JSON array.
	 */
	public JsonArray add(final Long value) {
		return null;
	}

	/**
	 * Adds a double to the JSON array.
	 */
	public JsonArray add(final Double value) {
		return null;
	}

	/**
	 * Adds a float to the JSON array.
	 */
	public JsonArray add(final Float value) {
		return null;
	}

	/**
	 * Adds a boolean to the JSON array.
	 */
	public JsonArray add(final Boolean value) {
		return null;
	}

	/**
	 * Adds a {@code null} value to the JSON array.
	 */
	public JsonArray addNull() {
		return null;
	}

	/**
	 * Adds a JSON object to the JSON array.
	 */
	public JsonArray add(final JsonObject value) {
		return null;
	}

	/**
	 * Adds another JSON array to the JSON array.
	 */
	public JsonArray add(final JsonArray value) {
		return null;
	}

	/**
	 * Adds a binary value to the JSON array.
	 * <p>
	 * JSON has no notion of binary so the binary will be base64 encoded to a String, and the String added.
	 */
	public JsonArray add(final byte[] value) {
		return null;
	}

	/**
	 * Adds an object to the JSON array.
	 */
	public JsonArray add(Object value) {
		return null;
	}

	/**
	 * Appends all of the elements in the specified array to the end of this JSON array.
	 */
	public JsonArray addAll(final JsonArray array) {
		return null;
	}

	// ---------------------------------------------------------------- misc

	/**
	 * Returns {@code true} if given value exist.
	 */
	public boolean contains(final Object value) {
		return false;
	}

	/**
	 * Removes the specified value from the JSON array.
	 */
	public boolean remove(final Object value) {
		return false;
	}

	/**
	 * Removes the value at the specified position in the JSON array.
	 */
	public Object remove(final int pos) {
		return null;
	}

	/**
	 * Returns the number of values in this JSON array.
	 */
	public int size() {
		return -1;
	}

	/**
	 * Returns {@code true} if JSON array is empty.
	 */
	public boolean isEmpty() {
		return false;
	}

	/**
	 * Returns the underlying list.
	 */
	public List<Object> list() {
		return null;
	}

	/**
	 * Removes all entries from the JSON array.
	 */
	public JsonArray clear() {
		return null;
	}

	/**
	 * Returns an iterator over the values in the JSON array.
	 */
	@Override
	public Iterator<Object> iterator() {
		return null;
	}
}
