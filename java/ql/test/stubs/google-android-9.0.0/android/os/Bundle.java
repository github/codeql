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
package android.os;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * A mapping from String keys to various {@link Parcelable} values.
 *
 * @see PersistableBundle
 */
public final class Bundle extends BaseBundle implements Cloneable, Parcelable {

    /**
     * Constructs a new, empty Bundle.
     */
    public Bundle() {
        super();
    }

    /**
     * Removes all elements from the mapping of this Bundle.
     */
    public void clear() {
    }

    /**
     * Removes any entry with the given key from the mapping of this Bundle.
     *
     * @param key a String key
     */
    public void remove(String key) {
    }

    /**
     * Inserts all mappings from the given Bundle into this Bundle.
     *
     * @param bundle a Bundle
     */
    public void putAll(Bundle bundle) {
    }

    /**
     * Return the size of {@link #mParcelledData} in bytes if available, otherwise
     * {@code 0}.
     *
     * @hide
     */
    public int getSize() {
        return -1;
    }

    /**
     * Inserts a byte value into the mapping of this Bundle, replacing any existing
     * value for the given key.
     *
     * @param key   a String, or null
     * @param value a byte
     */
    public void putByte(String key, byte value) {
    }

    /**
     * Inserts a char value into the mapping of this Bundle, replacing any existing
     * value for the given key.
     *
     * @param key   a String, or null
     * @param value a char
     */
    public void putChar(String key, char value) {
    }

    /**
     * Inserts a short value into the mapping of this Bundle, replacing any existing
     * value for the given key.
     *
     * @param key   a String, or null
     * @param value a short
     */
    public void putShort(String key, short value) {
    }

    /**
     * Inserts a float value into the mapping of this Bundle, replacing any existing
     * value for the given key.
     *
     * @param key   a String, or null
     * @param value a float
     */
    public void putFloat(String key, float value) {
    }

    /**
     * Inserts a CharSequence value into the mapping of this Bundle, replacing any
     * existing value for the given key. Either key or value may be null.
     *
     * @param key   a String, or null
     * @param value a CharSequence, or null
     */
    public void putCharSequence(String key, CharSequence value) {
    }

    /**
     * Inserts an ArrayList<Integer> value into the mapping of this Bundle,
     * replacing any existing value for the given key. Either key or value may be
     * null.
     *
     * @param key   a String, or null
     * @param value an ArrayList<Integer> object, or null
     */
    public void putIntegerArrayList(String key, ArrayList<Integer> value) {
    }

    /**
     * Inserts an ArrayList<String> value into the mapping of this Bundle, replacing
     * any existing value for the given key. Either key or value may be null.
     *
     * @param key   a String, or null
     * @param value an ArrayList<String> object, or null
     */
    public void putStringArrayList(String key, ArrayList<String> value) {
    }

    /**
     * Inserts an ArrayList<CharSequence> value into the mapping of this Bundle,
     * replacing any existing value for the given key. Either key or value may be
     * null.
     *
     * @param key   a String, or null
     * @param value an ArrayList<CharSequence> object, or null
     */
    public void putCharSequenceArrayList(String key, ArrayList<CharSequence> value) {
    }

    /**
     * Inserts a Serializable value into the mapping of this Bundle, replacing any
     * existing value for the given key. Either key or value may be null.
     *
     * @param key   a String, or null
     * @param value a Serializable object, or null
     */
    public void putSerializable(String key, Serializable value) {
    }

    /**
     * Inserts a byte array value into the mapping of this Bundle, replacing any
     * existing value for the given key. Either key or value may be null.
     *
     * @param key   a String, or null
     * @param value a byte array object, or null
     */
    public void putByteArray(String key, byte[] value) {
    }

    /**
     * Inserts a short array value into the mapping of this Bundle, replacing any
     * existing value for the given key. Either key or value may be null.
     *
     * @param key   a String, or null
     * @param value a short array object, or null
     */
    public void putShortArray(String key, short[] value) {
    }

    /**
     * Inserts a char array value into the mapping of this Bundle, replacing any
     * existing value for the given key. Either key or value may be null.
     *
     * @param key   a String, or null
     * @param value a char array object, or null
     */
    public void putCharArray(String key, char[] value) {
    }

    /**
     * Inserts a float array value into the mapping of this Bundle, replacing any
     * existing value for the given key. Either key or value may be null.
     *
     * @param key   a String, or null
     * @param value a float array object, or null
     */
    public void putFloatArray(String key, float[] value) {
    }

    /**
     * Inserts a CharSequence array value into the mapping of this Bundle, replacing
     * any existing value for the given key. Either key or value may be null.
     *
     * @param key   a String, or null
     * @param value a CharSequence array object, or null
     */
    public void putCharSequenceArray(String key, CharSequence[] value) {
    }

    /**
     * Inserts a Bundle value into the mapping of this Bundle, replacing any
     * existing value for the given key. Either key or value may be null.
     *
     * @param key   a String, or null
     * @param value a Bundle object, or null
     */
    public void putBundle(String key, Bundle value) {
    }

    /**
     * Returns the value associated with the given key, or (byte) 0 if no mapping of
     * the desired type exists for the given key.
     *
     * @param key a String
     * @return a byte value
     */
    public byte getByte(String key) {
        return -1;
    }

    /**
     * Returns the value associated with the given key, or defaultValue if no
     * mapping of the desired type exists for the given key.
     *
     * @param key          a String
     * @param defaultValue Value to return if key does not exist
     * @return a byte value
     */
    public Byte getByte(String key, byte defaultValue) {
        return -1;
    }

    /**
     * Returns the value associated with the given key, or (char) 0 if no mapping of
     * the desired type exists for the given key.
     *
     * @param key a String
     * @return a char value
     */
    public char getChar(String key) {
        return 'a';
    }

    /**
     * Returns the value associated with the given key, or defaultValue if no
     * mapping of the desired type exists for the given key.
     *
     * @param key          a String
     * @param defaultValue Value to return if key does not exist
     * @return a char value
     */
    public char getChar(String key, char defaultValue) {
        return 'a';
    }

    /**
     * Returns the value associated with the given key, or (short) 0 if no mapping
     * of the desired type exists for the given key.
     *
     * @param key a String
     * @return a short value
     */
    public short getShort(String key) {
        return -1;
    }

    /**
     * Returns the value associated with the given key, or defaultValue if no
     * mapping of the desired type exists for the given key.
     *
     * @param key          a String
     * @param defaultValue Value to return if key does not exist
     * @return a short value
     */
    public short getShort(String key, short defaultValue) {
        return -1;
    }

    /**
     * Returns the value associated with the given key, or 0.0f if no mapping of the
     * desired type exists for the given key.
     *
     * @param key a String
     * @return a float value
     */
    public float getFloat(String key) {
        return -1;
    }

    /**
     * Returns the value associated with the given key, or defaultValue if no
     * mapping of the desired type exists for the given key.
     *
     * @param key          a String
     * @param defaultValue Value to return if key does not exist
     * @return a float value
     */
    public float getFloat(String key, float defaultValue) {
        return -1;
    }

    /**
     * Returns the value associated with the given key, or null if no mapping of the
     * desired type exists for the given key or a null value is explicitly
     * associated with the key.
     *
     * @param key a String, or null
     * @return a CharSequence value, or null
     */
    public CharSequence getCharSequence(String key) {
        return null;
    }

    /**
     * Returns the value associated with the given key, or defaultValue if no
     * mapping of the desired type exists for the given key or if a null value is
     * explicitly associatd with the given key.
     *
     * @param key          a String, or null
     * @param defaultValue Value to return if key does not exist or if a null value
     *                     is associated with the given key.
     * @return the CharSequence value associated with the given key, or defaultValue
     *         if no valid CharSequence object is currently mapped to that key.
     */
    public CharSequence getCharSequence(String key, CharSequence defaultValue) {
        return null;
    }

    /**
     * Returns the value associated with the given key, or null if no mapping of the
     * desired type exists for the given key or a null value is explicitly
     * associated with the key.
     *
     * @param key a String, or null
     * @return a Bundle value, or null
     */
    public Bundle getBundle(String key) {
        return null;
    }

    /**
     * Returns the value associated with the given key, or null if no mapping of the
     * desired type exists for the given key or a null value is explicitly
     * associated with the key.
     *
     * @param key a String, or null
     * @return an ArrayList<T> value, or null
     */
    public <T extends Parcelable> ArrayList<T> getParcelableArrayList(String key) {
        return null;
    }

    /**
     * Returns the value associated with the given key, or null if no mapping of the
     * desired type exists for the given key or a null value is explicitly
     * associated with the key.
     *
     * @param key a String, or null
     * @return a Serializable value, or null
     */
    public Serializable getSerializable(String key) {
        return null;
    }

    /**
     * Returns the value associated with the given key, or null if no mapping of the
     * desired type exists for the given key or a null value is explicitly
     * associated with the key.
     *
     * @param key a String, or null
     * @return an ArrayList<String> value, or null
     */
    public ArrayList<Integer> getIntegerArrayList(String key) {
        return null;
    }

    /**
     * Returns the value associated with the given key, or null if no mapping of the
     * desired type exists for the given key or a null value is explicitly
     * associated with the key.
     *
     * @param key a String, or null
     * @return an ArrayList<String> value, or null
     */
    public ArrayList<String> getStringArrayList(String key) {
        return null;
    }

    /**
     * Returns the value associated with the given key, or null if no mapping of the
     * desired type exists for the given key or a null value is explicitly
     * associated with the key.
     *
     * @param key a String, or null
     * @return an ArrayList<CharSequence> value, or null
     */
    public ArrayList<CharSequence> getCharSequenceArrayList(String key) {
        return null;
    }

    /**
     * Returns the value associated with the given key, or null if no mapping of the
     * desired type exists for the given key or a null value is explicitly
     * associated with the key.
     *
     * @param key a String, or null
     * @return a byte[] value, or null
     */
    public byte[] getByteArray(String key) {
        return null;
    }

    /**
     * Returns the value associated with the given key, or null if no mapping of the
     * desired type exists for the given key or a null value is explicitly
     * associated with the key.
     *
     * @param key a String, or null
     * @return a short[] value, or null
     */
    public short[] getShortArray(String key) {
        return null;
    }

    /**
     * Returns the value associated with the given key, or null if no mapping of the
     * desired type exists for the given key or a null value is explicitly
     * associated with the key.
     *
     * @param key a String, or null
     * @return a char[] value, or null
     */
    public char[] getCharArray(String key) {
        return null;
    }

    /**
     * Returns the value associated with the given key, or null if no mapping of the
     * desired type exists for the given key or a null value is explicitly
     * associated with the key.
     *
     * @param key a String, or null
     * @return a float[] value, or null
     */
    public float[] getFloatArray(String key) {
        return null;
    }

    /**
     * Returns the value associated with the given key, or null if no mapping of the
     * desired type exists for the given key or a null value is explicitly
     * associated with the key.
     *
     * @param key a String, or null
     * @return a CharSequence[] value, or null
     */
    public CharSequence[] getCharSequenceArray(String key) {
        return null;
    }

    /**
     * Writes the Bundle contents to a Parcel, typically in order for it to be
     * passed through an IBinder connection.
     * 
     * @param parcel The parcel to copy this bundle to.
     */
    public void writeToParcel(Parcel parcel, int flags) {
    }

    /**
     * Reads the Parcel contents into this Bundle, typically in order for it to be
     * passed through an IBinder connection.
     * 
     * @param parcel The parcel to overwrite this bundle from.
     */
    public void readFromParcel(Parcel parcel) {
    }

    public synchronized String toString() {
        return null;
    }

    /**
     * @hide
     */
    public synchronized String toShortString() {
        return null;
    }
}