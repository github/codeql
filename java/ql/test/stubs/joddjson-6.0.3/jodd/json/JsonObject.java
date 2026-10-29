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
import java.util.Set;

/**
 * Representation of JSON object.
 * @see JsonArray
 */
public class JsonObject implements Iterable<Map.Entry<String, Object>> {

	/**
	 * Create a new, empty instance.
	 */
	public JsonObject() {
	}

	/**
	 * Create an instance from a Map. The Map is not copied.
	 */
	public JsonObject(final Map<String, Object> map) {
	}

	/**
	 * Returns the string value with the specified key.
	 */
	public String getString(final String key) {
		return null;
	}

	/**
	 * returns the integer value with the specified key.
	 */
	public Integer getInteger(final String key) {
		return null;
	}

	/**
	 * Returns the long value with the specified key.
	 */
	public Long getLong(final String key) {
		return null;
	}

	/**
	 * Returns the double value with the specified key.
	 */
	public Double getDouble(final String key) {
		return null;
	}

	/**
	 * Returns the float value with the specified key.
	 */
	public Float getFloat(final String key) {
		return null;
	}

	/**
	 * Returns the boolean value with the specified key.
	 */
	public Boolean getBoolean(final String key) {
		return false;
	}

	/**
	 * Returns the {@code JsonObject} value with the specified key.
	 */
	public JsonObject getJsonObject(final String key) {
		return null;
	}

	/**
	 * Returns the {@link JsonArray} value with the specified key
	 */
	public JsonArray getJsonArray(final String key) {
		return null;
	}

	/**
	 * Returns the binary value with the specified key.
	 * <p>
	 * JSON itself has no notion of a binary. This extension complies to the RFC-7493.
	 * THe byte array is Base64 encoded binary.
	 */
	public byte[] getBinary(final String key) {
		return null;
	}

	/**
	 * Returns the value with the specified key, as an object.
	 */
	@SuppressWarnings("unchecked")
	public <T> T getValue(final String key) {
		return null;
	}

	/**
	 * Like {@link #getString(String)} but specifies a default value to return if there is no entry.
	 */
	public String getString(final String key, final String def) {
		return null;
	}

	/**
	 * Like {@link #getInteger(String)} but specifies a default value to return if there is no entry.
	 */
	public Integer getInteger(final String key, final Integer def) {
		return null;
	}

	/**
	 * Like {@link #getLong(String)} but specifies a default value to return if there is no entry.
	 */
	public Long getLong(final String key, final Long def) {
		return null;
	}

	/**
	 * Like {@link #getDouble(String)} but specifies a default value to return if there is no entry.
	 */
	public Double getDouble(final String key, final Double def) {
		return null;
	}

	/**
	 * Like {@link #getFloat(String)} but specifies a default value to return if there is no entry.
	 */
	public Float getFloat(final String key, final Float def) {
		return null;
	}

	/**
	 * Like {@link #getBoolean(String)} but specifies a default value to return if there is no entry.
	 */
	public Boolean getBoolean(final String key, final Boolean def) {
		return null;
	}

	/**
	 * Like {@link #getJsonObject(String)} but specifies a default value to return if there is no entry.
	 */
	public JsonObject getJsonObject(final String key, final JsonObject def) {
		return null;
	}

	/**
	 * Like {@link #getJsonArray(String)} but specifies a default value to return if there is no entry.
	 */
	public JsonArray getJsonArray(final String key, final JsonArray def) {
		return null;
	}

	/**
	 * Like {@link #getBinary(String)} but specifies a default value to return if there is no entry.
	 */
	public byte[] getBinary(final String key, final byte[] def) {
		return null;
	}

	/**
	 * Like {@link #getValue(String)} but specifies a default value to return if there is no entry.
	 */
	public <T> T getValue(final String key, final T def) {
		return null;
	}

	/**
	 * Returns {@code true} if the JSON object contain the specified key.
	 */
	public boolean containsKey(final String key) {
		return false;
	}

	/**
	 * Return the set of field names in the JSON objects.
	 */
	public Set<String> fieldNames() {
		return null;
	}

	// ---------------------------------------------------------------- put

	/**
	 * Puts an Enum into the JSON object with the specified key.
	 * <p>
	 * JSON has no concept of encoding Enums, so the Enum will be converted to a String using the {@code java.lang.Enum#name}
	 * method and the value put as a String.
	 */
	public JsonObject put(final String key, final Enum value) {
		return null;
	}

	/**
	 * Puts an {@code CharSequence} into the JSON object with the specified key.
	 */
	public JsonObject put(final String key, final CharSequence value) {
		return null;
	}

	/**
	 * Puts a string into the JSON object with the specified key.
	 */
	public JsonObject put(final String key, final String value) {
		return null;
	}

	/**
	 * Puts an integer into the JSON object with the specified key.
	 */
	public JsonObject put(final String key, final Integer value) {
		return null;
	}

	/**
	 * Puts a long into the JSON object with the specified key.
	 */
	public JsonObject put(final String key, final Long value) {
		return null;
	}

	/**
	 * Puts a double into the JSON object with the specified key.
	 */
	public JsonObject put(final String key, final Double value) {
		return null;
	}

	/**
	 * Puts a float into the JSON object with the specified key.
	 */
	public JsonObject put(final String key, final Float value) {
		return null;
	}

	/**
	 * Puts a boolean into the JSON object with the specified key.
	 */
	public JsonObject put(final String key, final Boolean value) {
		return null;
	}

	/**
	 * Puts a {@code null} value into the JSON object with the specified key.
	 */
	public JsonObject putNull(final String key) {
		return null;
	}

	/**
	 * Puts another JSON object into the JSON object with the specified key.
	 */
	public JsonObject put(final String key, final JsonObject value) {
		return null;
	}

	/**
	 * Puts a {@link JsonArray} into the JSON object with the specified key.
	 */
	public JsonObject put(final String key, final JsonArray value) {
		return null;
	}

	/**
	 * Puts a {@code byte[]} into the JSON object with the specified key.
	 * <p>
	 * Follows JSON extension RFC7493, where binary will first be Base64
	 * encoded before being put as a String.
	 */
	public JsonObject put(final String key, final byte[] value) {
		return null;
	}

	/**
	 * Puts an object into the JSON object with the specified key.
	 */
	public JsonObject put(final String key, Object value) {
		return null;
	}

	@SuppressWarnings("StatementWithEmptyBody")
	static Object resolveValue(Object value) {
		return null;
	}


	/**
	 * Removes an entry from this object.
	 */
	public Object remove(final String key) {
		return null;
	}

	/**
	 * Merges in another JSON object.
	 * <p>
	 * This is the equivalent of putting all the entries of the other JSON object into this object. This is not a deep
	 * merge, entries containing (sub) JSON objects will be replaced entirely.
	 */
	public JsonObject mergeIn(final JsonObject other) {
		return null;
	}

	/**
	 * Merges in another JSON object.
	 * A deep merge (recursive) matches (sub) JSON objects in the existing tree and replaces all
	 * matching entries. JsonArrays are treated like any other entry, i.e. replaced entirely.
	 */
	public JsonObject mergeInDeep(final JsonObject other) {
		return null;
	}

	/**
	 * Merges in another JSON object.
	 * The merge is deep (recursive) to the specified level. If depth is 0, no merge is performed,
	 * if depth is greater than the depth of one of the objects, a full deep merge is performed.
	 */
	@SuppressWarnings("unchecked")
	public JsonObject mergeIn(final JsonObject other, final int depth) {
		return null;
	}

	/**
	 * Returns the underlying {@code Map} as is.
	 */
	public Map<String, Object> map() {
		return null;
	}

	/**
	 * Returns an iterator of the entries in the JSON object.
	 */
	@Override
	public Iterator<Map.Entry<String, Object>> iterator() {
		return null;
	}

	/**
	 * Returns the number of entries in the JSON object.
	 */
	public int size() {
		return -1;
	}

	/**
	 * Removes all the entries in this JSON object.
	 */
	public JsonObject clear() {
		return null;
	}

	/**
	 * Returns {@code true} if JSON object is empty.
	 */
	public boolean isEmpty() {
		return false;
	}
}
