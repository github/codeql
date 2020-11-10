/*
 * Copyright (C) 2014 The Android Open Source Project
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
import java.util.Set;

/**
 * A mapping from String keys to values of various types. In most cases, you
 * should work directly with either the {@link Bundle} or
 * {@link PersistableBundle} subclass.
 */
public class BaseBundle {
    /**
     * Constructs a new, empty Bundle that uses a specific ClassLoader for
     * instantiating Parcelable and Serializable objects.
     *
     * @param loader   An explicit ClassLoader to use when instantiating objects
     *                 inside of the Bundle.
     * @param capacity Initial size of the ArrayMap.
     */
    BaseBundle(ClassLoader loader, int capacity) {
    }

    /**
     * Constructs a new, empty Bundle.
     */
    BaseBundle() {
    }

    /**
     * Constructs a Bundle whose data is stored as a Parcel. The data will be
     * unparcelled on first contact, using the assigned ClassLoader.
     *
     * @param parcelledData a Parcel containing a Bundle
     */
    BaseBundle(Parcel parcelledData) {
    }

    BaseBundle(Parcel parcelledData, int length) {
    }

    /**
     * Constructs a new, empty Bundle that uses a specific ClassLoader for
     * instantiating Parcelable and Serializable objects.
     *
     * @param loader An explicit ClassLoader to use when instantiating objects
     *               inside of the Bundle.
     */
    BaseBundle(ClassLoader loader) {
    }

    /**
     * Constructs a new, empty Bundle sized to hold the given number of elements.
     * The Bundle will grow as needed.
     *
     * @param capacity the initial capacity of the Bundle
     */
    BaseBundle(int capacity) {
    }

    /**
     * Constructs a Bundle containing a copy of the mappings from the given Bundle.
     *
     * @param b a Bundle to be copied.
     */
    BaseBundle(BaseBundle b) {
    }

    /**
     * Special constructor that does not initialize the bundle.
     */
    BaseBundle(boolean doInit) {
    }

    /**
     * TODO: optimize this later (getting just the value part of a Bundle with a
     * single pair) once Bundle.forPair() above is implemented with a special
     * single-value Map implementation/serialization.
     *
     * Note: value in single-pair Bundle may be null.
     *
     * @hide
     */
    public String getPairValue() {
    }

    /**
     * Changes the ClassLoader this Bundle uses when instantiating objects.
     *
     * @param loader An explicit ClassLoader to use when instantiating objects
     *               inside of the Bundle.
     */
    void setClassLoader(ClassLoader loader) {
    }

    /**
     * Return the ClassLoader currently associated with this Bundle.
     */
    ClassLoader getClassLoader() {
        return null;
    }

    /**
     * @hide
     */
    public boolean isParcelled() {
        return false;
    }

    /**
     * @hide
     */
    public boolean isEmptyParcel() {
        return false;
    }

    /**
     * Returns true if the given key is contained in the mapping
     * of this Bundle.
     *
     * @param key a String key
     * @return true if the key is part of the mapping, false otherwise
     */
    public boolean containsKey(String key) {
        return false;
    }

    /**
     * Returns the entry with the given key as an object.
     *
     * @param key a String key
     * @return an Object, or null
     */
    public Object get(String key) {
        return null;
    }
    
    /**
     * Removes any entry with the given key from the mapping of this Bundle.
     *
     * @param key a String key
     */
    public void remove(String key) {
    }

    /** {@hide} */
    public void putObject(String key, Object value) {
    }    

    /**
     * Inserts a Boolean value into the mapping of this Bundle, replacing
     * any existing value for the given key.  Either key or value may be null.
     *
     * @param key a String, or null
     * @param value a boolean
     */
    public void putBoolean(String key, boolean value) {
    }

    /**
     * Inserts a byte value into the mapping of this Bundle, replacing
     * any existing value for the given key.
     *
     * @param key a String, or null
     * @param value a byte
     */
    void putByte(String key, byte value) {
    }

    /**
     * Inserts a char value into the mapping of this Bundle, replacing
     * any existing value for the given key.
     *
     * @param key a String, or null
     * @param value a char
     */
    void putChar(String key, char value) {
    }

    /**
     * Inserts a short value into the mapping of this Bundle, replacing
     * any existing value for the given key.
     *
     * @param key a String, or null
     * @param value a short
     */
    void putShort(String key, short value) {
    }

    /**
     * Inserts an int value into the mapping of this Bundle, replacing
     * any existing value for the given key.
     *
     * @param key a String, or null
     * @param value an int
     */
    public void putInt(String key, int value) {
    }

    /**
     * Inserts a long value into the mapping of this Bundle, replacing
     * any existing value for the given key.
     *
     * @param key a String, or null
     * @param value a long
     */
    public void putLong(String key, long value) {
    }

    /**
     * Inserts a float value into the mapping of this Bundle, replacing
     * any existing value for the given key.
     *
     * @param key a String, or null
     * @param value a float
     */
    void putFloat(String key, float value) {
    }

    /**
     * Inserts a double value into the mapping of this Bundle, replacing
     * any existing value for the given key.
     *
     * @param key a String, or null
     * @param value a double
     */
    public void putDouble(String key, double value) {
    }

    /**
     * Inserts a String value into the mapping of this Bundle, replacing
     * any existing value for the given key.  Either key or value may be null.
     *
     * @param key a String, or null
     * @param value a String, or null
     */
    public void putString(String key, String value) {
    }

    /**
     * Inserts a CharSequence value into the mapping of this Bundle, replacing
     * any existing value for the given key.  Either key or value may be null.
     *
     * @param key a String, or null
     * @param value a CharSequence, or null
     */
    void putCharSequence(String key, CharSequence value) {
    }

    /**
     * Inserts an ArrayList<Integer> value into the mapping of this Bundle, replacing
     * any existing value for the given key.  Either key or value may be null.
     *
     * @param key a String, or null
     * @param value an ArrayList<Integer> object, or null
     */
    void putIntegerArrayList(String key, ArrayList<Integer> value) {
    }

    /**
     * Inserts an ArrayList<String> value into the mapping of this Bundle, replacing
     * any existing value for the given key.  Either key or value may be null.
     *
     * @param key a String, or null
     * @param value an ArrayList<String> object, or null
     */
    void putStringArrayList(String key, ArrayList<String> value) {
    }


    /**
     * Inserts an ArrayList<CharSequence> value into the mapping of this Bundle,
     * replacing any existing value for the given key. Either key or value may be
     * null.
     *
     * @param key   a String, or null
     * @param value an ArrayList<CharSequence> object, or null
     */
    void putCharSequenceArrayList(String key, ArrayList<CharSequence> value) {
    }

    /**
     * Inserts a Serializable value into the mapping of this Bundle, replacing any
     * existing value for the given key. Either key or value may be null.
     *
     * @param key   a String, or null
     * @param value a Serializable object, or null
     */
    void putSerializable(String key, Serializable value) {
    }

    /**
     * Inserts a boolean array value into the mapping of this Bundle, replacing any
     * existing value for the given key. Either key or value may be null.
     *
     * @param key   a String, or null
     * @param value a boolean array object, or null
     */
    public void putBooleanArray(String key, boolean[] value) {
    }

    /**
     * Inserts a byte array value into the mapping of this Bundle, replacing any
     * existing value for the given key. Either key or value may be null.
     *
     * @param key   a String, or null
     * @param value a byte array object, or null
     */
    void putByteArray(String key, byte[] value) {
    }

    /**
     * Inserts a short array value into the mapping of this Bundle, replacing any
     * existing value for the given key. Either key or value may be null.
     *
     * @param key   a String, or null
     * @param value a short array object, or null
     */
    void putShortArray(String key, short[] value) {
    }

    /**
     * Inserts a char array value into the mapping of this Bundle, replacing any
     * existing value for the given key. Either key or value may be null.
     *
     * @param key   a String, or null
     * @param value a char array object, or null
     */
    void putCharArray(String key, char[] value) {
    }

    /**
     * Inserts an int array value into the mapping of this Bundle, replacing any
     * existing value for the given key. Either key or value may be null.
     *
     * @param key   a String, or null
     * @param value an int array object, or null
     */
    public void putIntArray(String key, int[] value) {
    }

    /**
     * Inserts a long array value into the mapping of this Bundle, replacing any
     * existing value for the given key. Either key or value may be null.
     *
     * @param key   a String, or null
     * @param value a long array object, or null
     */
    public void putLongArray(String key, long[] value) {
    }

    /**
     * Inserts a float array value into the mapping of this Bundle, replacing any
     * existing value for the given key. Either key or value may be null.
     *
     * @param key   a String, or null
     * @param value a float array object, or null
     */
    void putFloatArray(String key, float[] value) {
    }

    /**
     * Inserts a double array value into the mapping of this Bundle, replacing any
     * existing value for the given key. Either key or value may be null.
     *
     * @param key   a String, or null
     * @param value a double array object, or null
     */
    public void putDoubleArray(String key, double[] value) {
    }

    /**
     * Inserts a String array value into the mapping of this Bundle, replacing any
     * existing value for the given key. Either key or value may be null.
     *
     * @param key   a String, or null
     * @param value a String array object, or null
     */
    public void putStringArray(String key, String[] value) {
    }

    /**
     * Inserts a CharSequence array value into the mapping of this Bundle, replacing
     * any existing value for the given key. Either key or value may be null.
     *
     * @param key   a String, or null
     * @param value a CharSequence array object, or null
     */
    void putCharSequenceArray(String key, CharSequence[] value) {
    }

    /**
     * Returns the value associated with the given key, or false if no mapping of
     * the desired type exists for the given key.
     *
     * @param key a String
     * @return a boolean value
     */
    public boolean getBoolean(String key) {
        return false;
    }

    /**
     * Returns the value associated with the given key, or defaultValue if no
     * mapping of the desired type exists for the given key.
     *
     * @param key          a String
     * @param defaultValue Value to return if key does not exist
     * @return a boolean value
     */
    public boolean getBoolean(String key, boolean defaultValue) {
        return false;
    }

    /**
     * Returns the value associated with the given key, or (byte) 0 if no mapping of
     * the desired type exists for the given key.
     *
     * @param key a String
     * @return a byte value
     */
    byte getByte(String key) {
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
    Byte getByte(String key, byte defaultValue) {
        return -1;
    }

    /**
     * Returns the value associated with the given key, or (char) 0 if no mapping of
     * the desired type exists for the given key.
     *
     * @param key a String
     * @return a char value
     */
    char getChar(String key) {
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
    char getChar(String key, char defaultValue) {
        return 'a';
    }

    /**
     * Returns the value associated with the given key, or (short) 0 if no mapping
     * of the desired type exists for the given key.
     *
     * @param key a String
     * @return a short value
     */
    short getShort(String key) {
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
    short getShort(String key, short defaultValue) {
        return -1;
    }

    /**
     * Returns the value associated with the given key, or 0 if no mapping of the
     * desired type exists for the given key.
     *
     * @param key a String
     * @return an int value
     */
    public int getInt(String key) {
        return -1;
    }

    /**
     * Returns the value associated with the given key, or defaultValue if no
     * mapping of the desired type exists for the given key.
     *
     * @param key          a String
     * @param defaultValue Value to return if key does not exist
     * @return an int value
     */
    public int getInt(String key, int defaultValue) {
        return -1;
    }

    /**
     * Returns the value associated with the given key, or 0L if no mapping of the
     * desired type exists for the given key.
     *
     * @param key a String
     * @return a long value
     */
    public long getLong(String key) {
        return -1;
    }

    /**
     * Returns the value associated with the given key, or defaultValue if no
     * mapping of the desired type exists for the given key.
     *
     * @param key          a String
     * @param defaultValue Value to return if key does not exist
     * @return a long value
     */
    public long getLong(String key, long defaultValue) {
        return -1;
    }

    /**
     * Returns the value associated with the given key, or 0.0f if no mapping of the
     * desired type exists for the given key.
     *
     * @param key a String
     * @return a float value
     */
    float getFloat(String key) {
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
    float getFloat(String key, float defaultValue) {
        return -1;
    }

    /**
     * Returns the value associated with the given key, or 0.0 if no mapping of the
     * desired type exists for the given key.
     *
     * @param key a String
     * @return a double value
     */
    public double getDouble(String key) {
        return -1;
    }

    /**
     * Returns the value associated with the given key, or defaultValue if no
     * mapping of the desired type exists for the given key.
     *
     * @param key          a String
     * @param defaultValue Value to return if key does not exist
     * @return a double value
     */
    public double getDouble(String key, double defaultValue) {
        return -1;
    }

    /**
     * Returns the value associated with the given key, or null if no mapping of the
     * desired type exists for the given key or a null value is explicitly
     * associated with the key.
     *
     * @param key a String, or null
     * @return a String value, or null
     */
    public String getString(String key) {
        return null;
    }

    /**
     * Returns the value associated with the given key, or defaultValue if no
     * mapping of the desired type exists for the given key or if a null value is
     * explicitly associated with the given key.
     *
     * @param key          a String, or null
     * @param defaultValue Value to return if key does not exist or if a null value
     *                     is associated with the given key.
     * @return the String value associated with the given key, or defaultValue if no
     *         valid String object is currently mapped to that key.
     */
    public String getString(String key, String defaultValue) {
        return null;
    }

    /**
     * Returns the value associated with the given key, or null if no mapping of the
     * desired type exists for the given key or a null value is explicitly
     * associated with the key.
     *
     * @param key a String, or null
     * @return a CharSequence value, or null
     */
    CharSequence getCharSequence(String key) {
        return null;
    }

    /**
     * Returns the value associated with the given key, or defaultValue if no
     * mapping of the desired type exists for the given key or if a null value is
     * explicitly associated with the given key.
     *
     * @param key          a String, or null
     * @param defaultValue Value to return if key does not exist or if a null value
     *                     is associated with the given key.
     * @return the CharSequence value associated with the given key, or defaultValue
     *         if no valid CharSequence object is currently mapped to that key.
     */
    CharSequence getCharSequence(String key, CharSequence defaultValue) {
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
    Serializable getSerializable(String key) {
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
    ArrayList<Integer> getIntegerArrayList(String key) {
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
    ArrayList<String> getStringArrayList(String key) {
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
    ArrayList<CharSequence> getCharSequenceArrayList(String key) {
        return null;
    }

    /**
     * Returns the value associated with the given key, or null if no mapping of the
     * desired type exists for the given key or a null value is explicitly
     * associated with the key.
     *
     * @param key a String, or null
     * @return a boolean[] value, or null
     */
    public boolean[] getBooleanArray(String key) {
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
    byte[] getByteArray(String key) {
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
    short[] getShortArray(String key) {
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
    char[] getCharArray(String key) {
        return null;
    }

    /**
     * Returns the value associated with the given key, or null if no mapping of the
     * desired type exists for the given key or a null value is explicitly
     * associated with the key.
     *
     * @param key a String, or null
     * @return an int[] value, or null
     */
    public int[] getIntArray(String key) {
        return null;
    }

    /**
     * Returns the value associated with the given key, or null if no mapping of the
     * desired type exists for the given key or a null value is explicitly
     * associated with the key.
     *
     * @param key a String, or null
     * @return a long[] value, or null
     */
    public long[] getLongArray(String key) {
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
    float[] getFloatArray(String key) {
        return null;
    }

    /**
     * Returns the value associated with the given key, or null if no mapping of the
     * desired type exists for the given key or a null value is explicitly
     * associated with the key.
     *
     * @param key a String, or null
     * @return a double[] value, or null
     */
    public double[] getDoubleArray(String key) {
        return null;
    }

    /**
     * Returns the value associated with the given key, or null if no mapping of the
     * desired type exists for the given key or a null value is explicitly
     * associated with the key.
     *
     * @param key a String, or null
     * @return a String[] value, or null
     */
    public String[] getStringArray(String key) {
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
    CharSequence[] getCharSequenceArray(String key) {
        return null;
    }

    /**
     * Writes the Bundle contents to a Parcel, typically in order for it to be
     * passed through an IBinder connection.
     * 
     * @param parcel The parcel to copy this bundle to.
     */
    void writeToParcelInner(Parcel parcel, int flags) {
    }

    /**
     * Reads the Parcel contents into this Bundle, typically in order for it to be
     * passed through an IBinder connection.
     * 
     * @param parcel The parcel to overwrite this bundle from.
     */
    void readFromParcelInner(Parcel parcel) {
    }

}
