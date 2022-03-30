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

import java.util.List;
import java.util.Map;

/**
 * Simple, developer-friendly JSON parser. It focuses on easy usage
 * and type mappings. Uses Jodd's type converters, so it is natural
 * companion for Jodd projects.
 * <p>
 * This JSON parser also works in {@link #lazy(boolean)} mode. This
 * mode is for top performance usage: parsing is done very, very lazy.
 * While you can use all the mappings and other tools, for best performance
 * the lazy mode should be used only with maps and lists (no special mappings).
 * Also, the performance has it's price: more memory consumption, because the
 * original input is hold until the result is in use.
 * <p>
 * See: http://www.ietf.org/rfc/rfc4627.txt
 */
public class JsonParser extends JsonParserBase {

	/**
	 * Static ctor.
	 */
	public static JsonParser create() {
		return null;
	}

	/**
	 * Creates a lazy implementation of the JSON parser.
	 */
	public static JsonParser createLazyOne() {
		return null;
	}

	public JsonParser() {
		super(false);
	}

	/**
	 * Enables 'loose' mode for parsing. When 'loose' mode is enabled,
	 * JSON parsers swallows also invalid JSONs:
	 * <ul>
	 *     <li>invalid escape character sequence is simply added to the output</li>
	 *     <li>strings can be quoted with single-quotes</li>
	 *     <li>strings can be unquoted, but may not contain escapes</li>
	 * </ul>
	 */
	public JsonParser looseMode(final boolean looseMode) {
		return null;
	}

	/**
	 * Defines if type conversion is strict. If not, all exceptions will be
	 * caught and replaced with {@code null}.
	 */
	public JsonParser strictTypes(final boolean strictTypes) {
		return null;
	}

	/**
	 * Defines how JSON parser works. In non-lazy mode, the whole JSON is parsed as it is.
	 * In the lazy mode, not everything is parsed, but some things are left lazy.
	 * This way we gain performance, especially on partial usage of the whole JSON.
	 * However, be aware that parser holds the input memory until the returned
	 * objects are disposed.
	 */
	public JsonParser lazy(final boolean lazy) {
		return null;
	}

	/**
	 * Maps a class to JSONs root.
	 */
	public JsonParser map(final Class target) {
		return null;
	}

	/**
	 * Maps a class to given path. For arrays, append <code>values</code>
	 * to the path to specify component type (if not specified by
	 * generics).
	 */
	public JsonParser map(final String path, final Class target) {
		return null;
	}

	/**
	 * Replaces type with mapped type for current path.
	 */
	protected Class replaceWithMappedTypeForPath(final Class target) {
		return null;
	}

	/**
	 * Sets local class meta-data name.
	 * <p>
	 * Note that by using the class meta-data name you may expose a security hole in case untrusted source
	 * manages to specify a class that is accessible through class loader and exposes set of methods and/or fields,
	 * access of which opens an actual security hole. Such classes are known as deserialization gadgets.
	 *
	 * Because of this, use of "default typing" is not encouraged in general, and in particular is recommended against
	 * if the source of content is not trusted. Conversely, default typing may be used for processing content in
	 * cases where both ends (sender and receiver) are controlled by same entity.
	 */
	public JsonParser setClassMetadataName(final String name) {
		return null;
	}

	/**
	 * Sets usage of default class meta-data name.
	 * Using it may introduce a security hole, see {@link #setClassMetadataName(String)} for more details.
	 * @see #setClassMetadataName(String)
	 */
	public JsonParser withClassMetadata(final boolean useMetadata) {
		return null;
	}

	/**
	 * Adds a {@link jodd.util.Wildcard wildcard} pattern for white-listing classes.
	 * @see #setClassMetadataName(String)
	 */
	public JsonParser allowClass(final String classPattern) {
		return null;
	}

	/**
	 * Removes the whitelist of allowed classes.
	 * @see #setClassMetadataName(String)
	 */
	public JsonParser allowAllClasses() {
		return null;
	}

	/**
	 * Parses input JSON as given type.
	 */
	@SuppressWarnings("unchecked")
	public <T> T parse(final String input, final Class<T> targetType) {
		return null;
	}

	/**
	 * Parses input JSON to {@link JsonObject}, special case of {@link #parse(String, Class)}.
	 */
	public JsonObject parseAsJsonObject(final String input) {
		return null;
	}

	/**
	 * Parses input JSON to {@link JsonArray}, special case of parsing.
	 */
	public JsonArray parseAsJsonArray(final String input) {
		return null;
	}

	/**
	 * Parses input JSON to a list with specified component type.
	 */
	public <T> List<T> parseAsList(final String string, final Class<T> componentType) {
		return null;
	}

	/**
	 * Parses input JSON to a list with specified key and value types.
	 */
	public <K, V> Map<K, V> parseAsMap(
		final String string, final Class<K> keyType, final Class<V> valueType) {
		return null;
	}

	/**
	 * Parses input JSON string.
	 */
	public <T> T parse(final String input) {
		return null;
	}

	/**
	 * Parses input JSON as given type.
	 */
	@SuppressWarnings("unchecked")
	public <T> T parse(final char[] input, final Class<T> targetType) {
		return null;
	}

	/**
	 * Parses input JSON char array.
	 */
	public <T> T parse(final char[] input) {
		return null;
	}
}
