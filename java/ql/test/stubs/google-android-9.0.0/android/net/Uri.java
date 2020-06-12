/*
 * Copyright (C) 2007 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package android.net;

import android.content.Intent;

import android.os.Parcel;
import android.os.Parcelable;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.AbstractList;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Objects;
import java.util.RandomAccess;
import java.util.Set;

/**
 * Immutable URI reference. A URI reference includes a URI and a fragment, the
 * component of the URI following a '#'. Builds and parses URI references which
 * conform to <a href="http://www.faqs.org/rfcs/rfc2396.html">RFC 2396</a>.
 *
 * <p>
 * In the interest of performance, this class performs little to no validation.
 * Behavior is undefined for invalid input. This class is very forgiving--in the
 * face of invalid input, it will return garbage rather than throw an exception
 * unless otherwise specified.
 */
public abstract class Uri implements Parcelable, Comparable<Uri> {
    /*
     * This class aims to do as little up front work as possible. To accomplish
     * that, we vary the implementation depending on what the user passes in. For
     * example, we have one implementation if the user passes in a URI string
     * (StringUri) and another if the user passes in the individual components
     * (OpaqueUri). Concurrency notes*: Like any truly immutable object, this class
     * is safe for concurrent use. This class uses a caching pattern in some places
     * where it doesn't use volatile or synchronized. This is safe to do with ints
     * because getting or setting an int is atomic. It's safe to do with a String
     * because the internal fields are final and the memory model guarantees other
     * threads won't see a partially initialized instance. We are not guaranteed
     * that some threads will immediately see changes from other threads on certain
     * platforms, but we don't mind if those threads reconstruct the cached result.
     * As a result, we get thread safe caching with no concurrency overhead, which
     * means the most common case, access from a single thread, is as fast as
     * possible. From the Java Language spec.: "17.5 Final Field Semantics ... when
     * the object is seen by another thread, that thread will always see the
     * correctly constructed version of that object's final fields. It will also see
     * versions of any object or array referenced by those final fields that are at
     * least as up-to-date as the final fields are." In that same vein, all
     * non-transient fields within Uri implementations should be final and immutable
     * so as to ensure true immutability for clients even when they don't use proper
     * concurrency control. For reference, from RFC 2396: "4.3. Parsing a URI
     * Reference A URI reference is typically parsed according to the four main
     * components and fragment identifier in order to determine what components are
     * present and whether the reference is relative or absolute. The individual
     * components are then parsed for their subparts and, if not opaque, to verify
     * their validity. Although the BNF defines what is allowed in each component,
     * it is ambiguous in terms of differentiating between an authority component
     * and a path component that begins with two slash characters. The greedy
     * algorithm is used for disambiguation: the left-most matching rule soaks up as
     * much of the URI reference string as it is capable of matching. In other
     * words, the authority component wins." The "four main components" of a
     * hierarchical URI consist of <scheme>://<authority><path>?<query>
     */

    /**
     * NOTE: EMPTY accesses this field during its own initialization, so this field
     * *must* be initialized first, or else EMPTY will see a null value!
     *
     * Placeholder for strings which haven't been cached. This enables us to cache
     * null. We intentionally create a new String instance so we can compare its
     * identity and there is no chance we will confuse it with user data.
     */

    /**
     * Returns true if this URI is hierarchical like "http://google.com". Absolute
     * URIs are hierarchical if the scheme-specific part starts with a '/'. Relative
     * URIs are always hierarchical.
     */
    public abstract boolean isHierarchical();

    /**
     * Returns true if this URI is opaque like "mailto:nobody@google.com". The
     * scheme-specific part of an opaque URI cannot start with a '/'.
     */
    public boolean isOpaque() {
        return false;
    }

    /**
     * Returns true if this URI is relative, i.e.&nbsp;if it doesn't contain an
     * explicit scheme.
     *
     * @return true if this URI is relative, false if it's absolute
     */
    public abstract boolean isRelative();

    /**
     * Returns true if this URI is absolute, i.e.&nbsp;if it contains an explicit
     * scheme.
     *
     * @return true if this URI is absolute, false if it's relative
     */
    public boolean isAbsolute() {
        return !isRelative();
    }

    /**
     * Gets the scheme of this URI. Example: "http"
     *
     * @return the scheme or null if this is a relative URI
     */
    public abstract String getScheme();

    /**
     * Gets the scheme-specific part of this URI, i.e.&nbsp;everything between the
     * scheme separator ':' and the fragment separator '#'. If this is a relative
     * URI, this method returns the entire URI. Decodes escaped octets.
     *
     * <p>
     * Example: "//www.google.com/search?q=android"
     *
     * @return the decoded scheme-specific-part
     */
    public abstract String getSchemeSpecificPart();

    /**
     * Gets the scheme-specific part of this URI, i.e.&nbsp;everything between the
     * scheme separator ':' and the fragment separator '#'. If this is a relative
     * URI, this method returns the entire URI. Leaves escaped octets intact.
     *
     * <p>
     * Example: "//www.google.com/search?q=android"
     *
     * @return the decoded scheme-specific-part
     */
    public abstract String getEncodedSchemeSpecificPart();

    /**
     * Gets the decoded authority part of this URI. For server addresses, the
     * authority is structured as follows:
     * {@code [ userinfo '@' ] host [ ':' port ]}
     *
     * <p>
     * Examples: "google.com", "bob@google.com:80"
     *
     * @return the authority for this URI or null if not present
     */
    public abstract String getAuthority();

    /**
     * Gets the encoded authority part of this URI. For server addresses, the
     * authority is structured as follows:
     * {@code [ userinfo '@' ] host [ ':' port ]}
     *
     * <p>
     * Examples: "google.com", "bob@google.com:80"
     *
     * @return the authority for this URI or null if not present
     */
    public abstract String getEncodedAuthority();

    /**
     * Gets the decoded user information from the authority. For example, if the
     * authority is "nobody@google.com", this method will return "nobody".
     *
     * @return the user info for this URI or null if not present
     */
    public abstract String getUserInfo();

    /**
     * Gets the encoded user information from the authority. For example, if the
     * authority is "nobody@google.com", this method will return "nobody".
     *
     * @return the user info for this URI or null if not present
     */
    public abstract String getEncodedUserInfo();

    /**
     * Gets the encoded host from the authority for this URI. For example, if the
     * authority is "bob@google.com", this method will return "google.com".
     *
     * @return the host for this URI or null if not present
     */
    public abstract String getHost();

    /**
     * Gets the port from the authority for this URI. For example, if the authority
     * is "google.com:80", this method will return 80.
     *
     * @return the port for this URI or -1 if invalid or not present
     */
    public abstract int getPort();

    /**
     * Gets the decoded path.
     *
     * @return the decoded path, or null if this is not a hierarchical URI (like
     *         "mailto:nobody@google.com") or the URI is invalid
     */
    public abstract String getPath();

    /**
     * Gets the encoded path.
     *
     * @return the encoded path, or null if this is not a hierarchical URI (like
     *         "mailto:nobody@google.com") or the URI is invalid
     */
    public abstract String getEncodedPath();

    /**
     * Gets the decoded query component from this URI. The query comes after the
     * query separator ('?') and before the fragment separator ('#'). This method
     * would return "q=android" for "http://www.google.com/search?q=android".
     *
     * @return the decoded query or null if there isn't one
     */
    public abstract String getQuery();

    /**
     * Gets the encoded query component from this URI. The query comes after the
     * query separator ('?') and before the fragment separator ('#'). This method
     * would return "q=android" for "http://www.google.com/search?q=android".
     *
     * @return the encoded query or null if there isn't one
     */
    public abstract String getEncodedQuery();

    /**
     * Gets the decoded fragment part of this URI, everything after the '#'.
     *
     * @return the decoded fragment or null if there isn't one
     */
    public abstract String getFragment();

    /**
     * Gets the encoded fragment part of this URI, everything after the '#'.
     *
     * @return the encoded fragment or null if there isn't one
     */
    public abstract String getEncodedFragment();

    /**
     * Gets the decoded path segments.
     *
     * @return decoded path segments, each without a leading or trailing '/'
     */
    public abstract List<String> getPathSegments();

    /**
     * Gets the decoded last segment in the path.
     *
     * @return the decoded last segment or null if the path is empty
     */
    public abstract String getLastPathSegment();

    /**
     * Compares this Uri to another object for equality. Returns true if the encoded
     * string representations of this Uri and the given Uri are equal. Case counts.
     * Paths are not normalized. If one Uri specifies a default port explicitly and
     * the other leaves it implicit, they will not be considered equal.
     */
    public boolean equals(Object o) {
        return false;
    }

    /**
     * Hashes the encoded string represention of this Uri consistently with
     * {@link #equals(Object)}.
     */
    public int hashCode() {
        return -1;
    }

    /**
     * Compares the string representation of this Uri with that of another.
     */
    public int compareTo(Uri other) {
        return -1;
    }

    /**
     * Returns the encoded string representation of this URI. Example:
     * "http://google.com/"
     */
    public abstract String toString();

    /**
     * Return a string representation of the URI that is safe to print to logs and
     * other places where PII should be avoided.
     * 
     * @hide
     */
    public String toSafeString() {
        return null;
    }

    /**
     * Creates a Uri which parses the given encoded URI string.
     *
     * @param uriString an RFC 2396-compliant, encoded URI
     * @throws NullPointerException if uriString is null
     * @return Uri for this given uri string
     */
    public static Uri parse(String uriString) {
        return null;
    }

    /**
     * Creates a Uri from a file. The URI has the form "file://<absolute path>".
     * Encodes path characters with the exception of '/'.
     *
     * <p>
     * Example: "file:///tmp/android.txt"
     *
     * @throws NullPointerException if file is null
     * @return a Uri for the given file
     */
    public static Uri fromFile(File file) {
        return null;
    }

    /**
     * Creates an opaque Uri from the given components. Encodes the ssp which means
     * this method cannot be used to create hierarchical URIs.
     *
     * @param scheme   of the URI
     * @param ssp      scheme-specific-part, everything between the scheme separator
     *                 (':') and the fragment separator ('#'), which will get
     *                 encoded
     * @param fragment fragment, everything after the '#', null if undefined, will
     *                 get encoded
     *
     * @throws NullPointerException if scheme or ssp is null
     * @return Uri composed of the given scheme, ssp, and fragment
     *
     * @see Builder if you don't want the ssp and fragment to be encoded
     */
    public static Uri fromParts(String scheme, String ssp, String fragment) {
        return null;
    }

    /**
     * Returns a set of the unique names of all query parameters. Iterating over the
     * set will return the names in order of their first occurrence.
     *
     * @throws UnsupportedOperationException if this isn't a hierarchical URI
     *
     * @return a set of decoded names
     */
    public Set<String> getQueryParameterNames() {
        return null;
    }

    /**
     * Searches the query string for parameter values with the given key.
     *
     * @param key which will be encoded
     *
     * @throws UnsupportedOperationException if this isn't a hierarchical URI
     * @throws NullPointerException          if key is null
     * @return a list of decoded values
     */
    public List<String> getQueryParameters(String key) {
        return null;
    }

    /**
     * Searches the query string for the first value with the given key.
     *
     * <p>
     * <strong>Warning:</strong> Prior to Jelly Bean, this decoded the '+' character
     * as '+' rather than ' '.
     *
     * @param key which will be encoded
     * @throws UnsupportedOperationException if this isn't a hierarchical URI
     * @throws NullPointerException          if key is null
     * @return the decoded value or null if no parameter is found
     */
    public String getQueryParameter(String key) {
        return null;
    }

    /**
     * Searches the query string for the first value with the given key and
     * interprets it as a boolean value. "false" and "0" are interpreted as
     * <code>false</code>, everything else is interpreted as <code>true</code>.
     *
     * @param key          which will be decoded
     * @param defaultValue the default value to return if there is no query
     *                     parameter for key
     * @return the boolean interpretation of the query parameter key
     */
    public boolean getBooleanQueryParameter(String key, boolean defaultValue) {
        return false;
    }

    /**
     * Return an equivalent URI with a lowercase scheme component. This aligns the
     * Uri with Android best practices for intent filtering.
     *
     * <p>
     * For example, "HTTP://www.android.com" becomes "http://www.android.com"
     *
     * <p>
     * All URIs received from outside Android (such as user input, or external
     * sources like Bluetooth, NFC, or the Internet) should be normalized before
     * they are used to create an Intent.
     *
     * <p class="note">
     * This method does <em>not</em> validate bad URI's, or 'fix' poorly formatted
     * URI's - so do not use it for input validation. A Uri will always be returned,
     * even if the Uri is badly formatted to begin with and a scheme component
     * cannot be found.
     *
     * @return normalized Uri (never null)
     * @see android.content.Intent#setData
     * @see android.content.Intent#setDataAndNormalize
     */
    public Uri normalizeScheme() {
        return null;
    }

    /**
     * Writes a Uri to a Parcel.
     *
     * @param out parcel to write to
     * @param uri to write, can be null
     */
    public static void writeToParcel(Parcel out, Uri uri) {
    }

    /**
     * Encodes characters in the given string as '%'-escaped octets using the UTF-8
     * scheme. Leaves letters ("A-Z", "a-z"), numbers ("0-9"), and unreserved
     * characters ("_-!.~'()*") intact. Encodes all other characters.
     *
     * @param s string to encode
     * @return an encoded version of s suitable for use as a URI component, or null
     *         if s is null
     */
    public static String encode(String s) {
        return null;
    }

    /**
     * Encodes characters in the given string as '%'-escaped octets using the UTF-8
     * scheme. Leaves letters ("A-Z", "a-z"), numbers ("0-9"), and unreserved
     * characters ("_-!.~'()*") intact. Encodes all other characters with the
     * exception of those specified in the allow argument.
     *
     * @param s     string to encode
     * @param allow set of additional characters to allow in the encoded form, null
     *              if no characters should be skipped
     * @return an encoded version of s suitable for use as a URI component, or null
     *         if s is null
     */
    public static String encode(String s, String allow) {
        return null;
    }

    /**
     * Decodes '%'-escaped octets in the given string using the UTF-8 scheme.
     * Replaces invalid octets with the unicode replacement character ("\\uFFFD").
     *
     * @param s encoded string to decode
     * @return the given string with escaped octets decoded, or null if s is null
     */
    public static String decode(String s) {
        return null;
    }

    /**
     * Creates a new Uri by appending an already-encoded path segment to a base Uri.
     *
     * @param baseUri     Uri to append path segment to
     * @param pathSegment encoded path segment to append
     * @return a new Uri based on baseUri with the given segment appended to the
     *         path
     * @throws NullPointerException if baseUri is null
     */
    public static Uri withAppendedPath(Uri baseUri, String pathSegment) {
        return null;
    }

    /**
     * If this {@link Uri} is {@code file://}, then resolve and return its canonical
     * path. Also fixes legacy emulated storage paths so they are usable across user
     * boundaries. Should always be called from the app process before sending
     * elsewhere.
     *
     * @hide
     */
    public Uri getCanonicalUri() {
        return null;
    }

    /**
     * If this is a {@code file://} Uri, it will be reported to {@link StrictMode}.
     *
     * @hide
     */
    public void checkFileUriExposed(String location) {
    }

    /**
     * If this is a {@code content://} Uri without access flags, it will be reported
     * to {@link StrictMode}.
     *
     * @hide
     */
    public void checkContentUriWithoutPermission(String location, int flags) {
    }

    /**
     * Test if this is a path prefix match against the given Uri. Verifies that
     * scheme, authority, and atomic path segments match.
     *
     * @hide
     */
    public boolean isPathPrefixMatch(Uri prefix) {
        return false;
    }
}
