/*
 * Copyright 2002-2020 the original author or authors.
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

package org.springframework.util;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.Serializable;
import java.nio.charset.Charset;
import java.util.BitSet;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.TreeSet;

import org.springframework.lang.Nullable;

/**
 * Represents a MIME Type, as originally defined in RFC 2046 and subsequently
 * used in other Internet protocols including HTTP.
 *
 * <p>This class, however, does not contain support for the q-parameters used
 * in HTTP content negotiation. Those can be found in the subclass
 * {@code org.springframework.http.MediaType} in the {@code spring-web} module.
 *
 * <p>Consists of a {@linkplain #getType() type} and a {@linkplain #getSubtype() subtype}.
 * Also has functionality to parse MIME Type values from a {@code String} using
 * {@link #valueOf(String)}. For more parsing options see {@link MimeTypeUtils}.
 *
 * @author Arjen Poutsma
 * @author Juergen Hoeller
 * @author Rossen Stoyanchev
 * @author Sam Brannen
 * @since 4.0
 * @see MimeTypeUtils
 */
public class MimeType implements Comparable<MimeType>, Serializable {

	protected static final String WILDCARD_TYPE = "";

	/**
	 * Create a new {@code MimeType} for the given primary type.
	 * <p>The {@linkplain #getSubtype() subtype} is set to <code>"&#42;"</code>,
	 * and the parameters are empty.
	 * @param type the primary type
	 * @throws IllegalArgumentException if any of the parameters contains illegal characters
	 */
	public MimeType(String type) {
	}

	/**
	 * Create a new {@code MimeType} for the given primary type and subtype.
	 * <p>The parameters are empty.
	 * @param type the primary type
	 * @param subtype the subtype
	 * @throws IllegalArgumentException if any of the parameters contains illegal characters
	 */
	public MimeType(String type, String subtype) {
	}

	/**
	 * Create a new {@code MimeType} for the given type, subtype, and character set.
	 * @param type the primary type
	 * @param subtype the subtype
	 * @param charset the character set
	 * @throws IllegalArgumentException if any of the parameters contains illegal characters
	 */
	public MimeType(String type, String subtype, Charset charset) {
	}

	/**
	 * Copy-constructor that copies the type, subtype, parameters of the given {@code MimeType},
	 * and allows to set the specified character set.
	 * @param other the other MimeType
	 * @param charset the character set
	 * @throws IllegalArgumentException if any of the parameters contains illegal characters
	 * @since 4.3
	 */
	public MimeType(MimeType other, Charset charset) {
	}

	/**
	 * Copy-constructor that copies the type and subtype of the given {@code MimeType},
	 * and allows for different parameter.
	 * @param other the other MimeType
	 * @param parameters the parameters (may be {@code null})
	 * @throws IllegalArgumentException if any of the parameters contains illegal characters
	 */
	public MimeType(MimeType other, @Nullable Map<String, String> parameters) {
	}

	/**
	 * Create a new {@code MimeType} for the given type, subtype, and parameters.
	 * @param type the primary type
	 * @param subtype the subtype
	 * @param parameters the parameters (may be {@code null})
	 * @throws IllegalArgumentException if any of the parameters contains illegal characters
	 */
	public MimeType(String type, String subtype, @Nullable Map<String, String> parameters) {
	}

	/**
	 * Copy-constructor that copies the type, subtype and parameters of the given {@code MimeType},
	 * skipping checks performed in other constructors.
	 * @param other the other MimeType
	 * @since 5.3
	 */
	protected MimeType(MimeType other) {
	}

	protected void checkParameters(String parameter, String value) {
	}
	
	protected String unquote(String s) {
		return null;
	}

	/**
	 * Indicates whether the {@linkplain #getType() type} is the wildcard character
	 * <code>&#42;</code> or not.
	 */
	public boolean isWildcardType() {
		return false;
	}

	/**
	 * Indicates whether the {@linkplain #getSubtype() subtype} is the wildcard
	 * character <code>&#42;</code> or the wildcard character followed by a suffix
	 * (e.g. <code>&#42;+xml</code>).
	 * @return whether the subtype is a wildcard
	 */
	public boolean isWildcardSubtype() {
		return false;
	}

	/**
	 * Indicates whether this MIME Type is concrete, i.e. whether neither the type
	 * nor the subtype is a wildcard character <code>&#42;</code>.
	 * @return whether this MIME Type is concrete
	 */
	public boolean isConcrete() {
		return false;
	}

	/**
	 * Return the primary type.
	 */
	public String getType() {
		return null;
	}

	/**
	 * Return the subtype.
	 */
	public String getSubtype() {
		return null;
	}

	/**
	 * Return the subtype suffix as defined in RFC 6839.
	 * @since 5.3
	 */
	@Nullable
	public String getSubtypeSuffix() {
		return null;
	}

	/**
	 * Return the character set, as indicated by a {@code charset} parameter, if any.
	 * @return the character set, or {@code null} if not available
	 * @since 4.3
	 */
	@Nullable
	public Charset getCharset() {
		return null;
	}

	/**
	 * Return a generic parameter value, given a parameter name.
	 * @param name the parameter name
	 * @return the parameter value, or {@code null} if not present
	 */
	@Nullable
	public String getParameter(String name) {
		return null;
	}

	/**
	 * Return all generic parameter values.
	 * @return a read-only map (possibly empty, never {@code null})
	 */
	public Map<String, String> getParameters() {
		return null;
	}

	/**
	 * Indicate whether this MIME Type includes the given MIME Type.
	 * <p>For instance, {@code text/*} includes {@code text/plain} and {@code text/html},
	 * and {@code application/*+xml} includes {@code application/soap+xml}, etc.
	 * This method is <b>not</b> symmetric.
	 * @param other the reference MIME Type with which to compare
	 * @return {@code true} if this MIME Type includes the given MIME Type;
	 * {@code false} otherwise
	 */
	public boolean includes(@Nullable MimeType other) {
		return false;
	}

	/**
	 * Indicate whether this MIME Type is compatible with the given MIME Type.
	 * <p>For instance, {@code text/*} is compatible with {@code text/plain},
	 * {@code text/html}, and vice versa. In effect, this method is similar to
	 * {@link #includes}, except that it <b>is</b> symmetric.
	 * @param other the reference MIME Type with which to compare
	 * @return {@code true} if this MIME Type is compatible with the given MIME Type;
	 * {@code false} otherwise
	 */
	public boolean isCompatibleWith(@Nullable MimeType other) {
		return false;
	}

	/**
	 * Similar to {@link #equals(Object)} but based on the type and subtype
	 * only, i.e. ignoring parameters.
	 * @param other the other mime type to compare to
	 * @return whether the two mime types have the same type and subtype
	 * @since 5.1.4
	 */
	public boolean equalsTypeAndSubtype(@Nullable MimeType other) {
		return false;
	}

	/**
	 * Unlike {@link Collection#contains(Object)} which relies on
	 * {@link MimeType#equals(Object)}, this method only checks the type and the
	 * subtype, but otherwise ignores parameters.
	 * @param mimeTypes the list of mime types to perform the check against
	 * @return whether the list contains the given mime type
	 * @since 5.1.4
	 */
	public boolean isPresentIn(Collection<? extends MimeType> mimeTypes) {
		return false;
	}


	@Override
	public boolean equals(@Nullable Object other) {
		return false;
	}

	/**
	 * Determine if the parameters in this {@code MimeType} and the supplied
	 * {@code MimeType} are equal, performing case-insensitive comparisons
	 * for {@link Charset Charsets}.
	 * @since 4.2
	 */
	private boolean parametersAreEqual(MimeType other) {
		return true;
	}

	@Override
	public int hashCode() {
		return 0;
	}

	@Override
	public String toString() {
		return null;
	}

	protected void appendTo(StringBuilder builder) {
	}

	/**
	 * Compares this MIME Type to another alphabetically.
	 * @param other the MIME Type to compare to
	 * @see MimeTypeUtils#sortBySpecificity(List)
	 */
	@Override
	public int compareTo(MimeType other) {
		return 0;
	}

	/**
	 * Parse the given String value into a {@code MimeType} object,
	 * with this method name following the 'valueOf' naming convention
	 * (as supported by {@link org.springframework.core.convert.ConversionService}.
	 * @see MimeTypeUtils#parseMimeType(String)
	 */
	public static MimeType valueOf(String value) {
		return null;
	}

	/**
	 * Comparator to sort {@link MimeType MimeTypes} in order of specificity.
	 *
	 * @param <T> the type of mime types that may be compared by this comparator
	 */
	public static class SpecificityComparator<T extends MimeType> implements Comparator<T> {

		@Override
		public int compare(T mimeType1, T mimeType2) {
			return 0;
		}

		protected int compareParameters(T mimeType1, T mimeType2) {
			return 0;
		}
	}

}
