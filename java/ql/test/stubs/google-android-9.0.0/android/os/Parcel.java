/*
 * Copyright (C) 2006 The Android Open Source Project
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

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileDescriptor;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.ObjectStreamClass;
import java.io.Serializable;
import java.lang.reflect.Array;
import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

public final class Parcel {

    /**
     * Retrieve a new Parcel object from the pool.
     */
    public static Parcel obtain() {
        return null;
    }

    /**
     * Write a byte array into the parcel at the current {@link #dataPosition},
     * growing {@link #dataCapacity} if needed.
     * 
     * @param b Bytes to place into the parcel.
     */
    public final void writeByteArray(byte[] b) {
    }

    /**
     * Write a byte array into the parcel at the current {@link #dataPosition},
     * growing {@link #dataCapacity} if needed.
     * 
     * @param b      Bytes to place into the parcel.
     * @param offset Index of first byte to be written.
     * @param len    Number of bytes to write.
     */
    public final void writeByteArray(byte[] b, int offset, int len) {
    }

    /**
     * Write a blob of data into the parcel at the current {@link #dataPosition},
     * growing {@link #dataCapacity} if needed.
     * 
     * @param b Bytes to place into the parcel. {@hide} {@SystemApi}
     */
    public final void writeBlob(byte[] b) {
    }

    /**
     * Write a blob of data into the parcel at the current {@link #dataPosition},
     * growing {@link #dataCapacity} if needed.
     * 
     * @param b      Bytes to place into the parcel.
     * @param offset Index of first byte to be written.
     * @param len    Number of bytes to write. {@hide} {@SystemApi}
     */
    public final void writeBlob(byte[] b, int offset, int len) {
    }

    /**
     * Write an integer value into the parcel at the current dataPosition(), growing
     * dataCapacity() if needed.
     */
    public final void writeInt(int val) {
    }

    /**
     * Write a long integer value into the parcel at the current dataPosition(),
     * growing dataCapacity() if needed.
     */
    public final void writeLong(long val) {
    }

    /**
     * Write a floating point value into the parcel at the current dataPosition(),
     * growing dataCapacity() if needed.
     */
    public final void writeFloat(float val) {
    }

    /**
     * Write a double precision floating point value into the parcel at the current
     * dataPosition(), growing dataCapacity() if needed.
     */
    public final void writeDouble(double val) {
    }

    /**
     * Write a string value into the parcel at the current dataPosition(), growing
     * dataCapacity() if needed.
     */
    public final void writeString(String val) {
    }

    /**
     * Write a string without going though a {@link ReadWriteHelper}. Subclasses of
     * {@link ReadWriteHelper} must use this method instead of {@link #writeString}
     * to avoid infinity recursive calls.
     *
     * @hide
     */
    public void writeStringNoHelper(String val) {
    }

    /** @hide */
    public final void writeBoolean(boolean val) {
    }

    /**
     * Write a CharSequence value into the parcel at the current dataPosition(),
     * growing dataCapacity() if needed.
     * 
     * @hide
     */
    public final void writeCharSequence(CharSequence val) {
    }

    /**
     * Write a byte value into the parcel at the current dataPosition(), growing
     * dataCapacity() if needed.
     */
    public final void writeByte(byte val) {
    }

    /**
     * Please use {@link #writeBundle} instead. Flattens a Map into the parcel at
     * the current dataPosition(), growing dataCapacity() if needed. The Map keys
     * must be String objects. The Map values are written using {@link #writeValue}
     * and must follow the specification there.
     *
     * <p>
     * It is strongly recommended to use {@link #writeBundle} instead of this
     * method, since the Bundle class provides a type-safe API that allows you to
     * avoid mysterious type errors at the point of marshalling.
     */
    public final void writeMap(Map val) {
    }

    /**
     * Flatten a Bundle into the parcel at the current dataPosition(), growing
     * dataCapacity() if needed.
     */
    public final void writeBundle(Bundle val) {
    }

    /**
     * Flatten a List into the parcel at the current dataPosition(), growing
     * dataCapacity() if needed. The List values are written using
     * {@link #writeValue} and must follow the specification there.
     */
    public final void writeList(List val) {
    }

    /**
     * Flatten an Object array into the parcel at the current dataPosition(),
     * growing dataCapacity() if needed. The array values are written using
     * {@link #writeValue} and must follow the specification there.
     */
    public final void writeArray(Object[] val) {
    }

    public final void writeBooleanArray(boolean[] val) {
    }

    public final boolean[] createBooleanArray() {
        return null;
    }

    public final void readBooleanArray(boolean[] val) {
    }

    public final void writeCharArray(char[] val) {
    }

    public final char[] createCharArray() {
        return null;
    }

    public final void readCharArray(char[] val) {
    }

    public final void writeIntArray(int[] val) {
    }

    public final int[] createIntArray() {
        return null;
    }

    public final void readIntArray(int[] val) {
    }

    public final void writeLongArray(long[] val) {
    }

    public final long[] createLongArray() {
        return null;
    }

    public final void readLongArray(long[] val) {
    }

    public final void writeFloatArray(float[] val) {
    }

    public final float[] createFloatArray() {
    }

    public final void readFloatArray(float[] val) {
    }

    public final void writeDoubleArray(double[] val) {
    }

    public final double[] createDoubleArray() {
        return null;
    }

    public final void readDoubleArray(double[] val) {
    }

    public final void writeStringArray(String[] val) {
    }

    public final String[] createStringArray() {
        return null;
    }

    public final void readStringArray(String[] val) {
    }

    /**
     * @hide
     */
    public final void writeCharSequenceArray(CharSequence[] val) {
    }

    /**
     * @hide
     */
    public final void writeCharSequenceList(ArrayList<CharSequence> val) {
    }

    /**
     * Flatten a List containing String objects into the parcel, at the current
     * dataPosition() and growing dataCapacity() if needed. They can later be
     * retrieved with {@link #createStringArrayList} or {@link #readStringList}.
     *
     * @param val The list of strings to be written.
     *
     * @see #createStringArrayList
     * @see #readStringList
     */
    public final void writeStringList(List<String> val) {
    }

    /**
     * Flatten a generic object in to a parcel. The given Object value may currently
     * be one of the following types:
     *
     * <ul>
     * <li>null
     * <li>String
     * <li>Byte
     * <li>Short
     * <li>Integer
     * <li>Long
     * <li>Float
     * <li>Double
     * <li>Boolean
     * <li>String[]
     * <li>boolean[]
     * <li>byte[]
     * <li>int[]
     * <li>long[]
     * <li>Object[] (supporting objects of the same type defined here).
     * <li>{@link Bundle}
     * <li>Map (as supported by {@link #writeMap}).
     * <li>Any object that implements the {@link Parcelable} protocol.
     * <li>Parcelable[]
     * <li>CharSequence (as supported by {@link TextUtils#writeToParcel}).
     * <li>List (as supported by {@link #writeList}).
     * <li>{@link SparseArray} (as supported by
     * {@link #writeSparseArray(SparseArray)}).
     * <li>{@link IBinder}
     * <li>Any object that implements Serializable (but see
     * {@link #writeSerializable} for caveats). Note that all of the previous types
     * have relatively efficient implementations for writing to a Parcel; having to
     * rely on the generic serialization approach is much less efficient and should
     * be avoided whenever possible.
     * </ul>
     *
     * <p class="caution">
     * {@link Parcelable} objects are written with {@link Parcelable#writeToParcel}
     * using contextual flags of 0. When serializing objects containing
     * {@link ParcelFileDescriptor}s, this may result in file descriptor leaks when
     * they are returned from Binder calls (where
     * {@link Parcelable#PARCELABLE_WRITE_RETURN_VALUE} should be used).
     * </p>
     */
    public final void writeValue(Object v) {
    }

    /**
     * Flatten the name of the class of the Parcelable and its contents into the
     * parcel.
     *
     * @param p               The Parcelable object to be written.
     * @param parcelableFlags Contextual flags as per
     *                        {@link Parcelable#writeToParcel(Parcel, int)
     *                        Parcelable.writeToParcel()}.
     */
    public final void writeParcelable(Parcelable p, int parcelableFlags) {
    }

    /** @hide */
    public final void writeParcelableCreator(Parcelable p) {
    }

    /**
     * Write a generic serializable object in to a Parcel. It is strongly
     * recommended that this method be avoided, since the serialization overhead is
     * extremely large, and this approach will be much slower than using the other
     * approaches to writing data in to a Parcel.
     */
    public final void writeSerializable(Serializable s) {
    }

    /**
     * Special function for writing an exception result at the header of a parcel,
     * to be used when returning an exception from a transaction. Note that this
     * currently only supports a few exception types; any other exception will be
     * re-thrown by this function as a RuntimeException (to be caught by the
     * system's last-resort exception handling when dispatching a transaction).
     *
     * <p>
     * The supported exception types are:
     * <ul>
     * <li>{@link BadParcelableException}
     * <li>{@link IllegalArgumentException}
     * <li>{@link IllegalStateException}
     * <li>{@link NullPointerException}
     * <li>{@link SecurityException}
     * <li>{@link UnsupportedOperationException}
     * <li>{@link NetworkOnMainThreadException}
     * </ul>
     *
     * @param e The Exception to be written.
     *
     * @see #writeNoException
     * @see #readException
     */
    public final void writeException(Exception e) {
    }

    /**
     * Special function for writing information at the front of the Parcel
     * indicating that no exception occurred.
     *
     * @see #writeException
     * @see #readException
     */
    public final void writeNoException() {
    }

    /**
     * Special function for reading an exception result from the header of a parcel,
     * to be used after receiving the result of a transaction. This will throw the
     * exception for you if it had been written to the Parcel, otherwise return and
     * let you read the normal result data from the Parcel.
     *
     * @see #writeException
     * @see #writeNoException
     */
    public final void readException() {
    }

    /**
     * Parses the header of a Binder call's response Parcel and returns the
     * exception code. Deals with lite or fat headers. In the common successful
     * case, this header is generally zero. In less common cases, it's a small
     * negative number and will be followed by an error string.
     *
     * This exists purely for android.database.DatabaseUtils and insulating it from
     * having to handle fat headers as returned by e.g. StrictMode-induced RPC
     * responses.
     *
     * @hide
     */
    public final int readExceptionCode() {
        return -1;
    }

    /**
     * Throw an exception with the given message. Not intended for use outside the
     * Parcel class.
     *
     * @param code Used to determine which exception class to throw.
     * @param msg  The exception message.
     */
    public final void readException(int code, String msg) {
    }

    /**
     * Read an integer value from the parcel at the current dataPosition().
     */
    public final int readInt() {
        return -1;
    }

    /**
     * Read a long integer value from the parcel at the current dataPosition().
     */
    public final long readLong() {
        return -1;
    }

    /**
     * Read a floating point value from the parcel at the current dataPosition().
     */
    public final float readFloat() {
        return -1;
    }

    /**
     * Read a double precision floating point value from the parcel at the current
     * dataPosition().
     */
    public final double readDouble() {
        return -1;
    }

    /**
     * Read a string value from the parcel at the current dataPosition().
     */
    public final String readString() {
        return null;
    }

    /** @hide */
    public final boolean readBoolean() {
        return false;
    }

    /**
     * Read a CharSequence value from the parcel at the current dataPosition().
     * 
     * @hide
     */
    public final CharSequence readCharSequence() {
        return null;
    }

    /**
     * Read a byte value from the parcel at the current dataPosition().
     */
    public final byte readByte() {
        return -1;
    }

    /**
     * Please use {@link #readBundle(ClassLoader)} instead (whose data must have
     * been written with {@link #writeBundle}. Read into an existing Map object from
     * the parcel at the current dataPosition().
     */
    public final void readMap(Map outVal, ClassLoader loader) {
    }

    /**
     * Read into an existing List object from the parcel at the current
     * dataPosition(), using the given class loader to load any enclosed
     * Parcelables. If it is null, the default class loader is used.
     */
    public final void readList(List outVal, ClassLoader loader) {
    }

    /**
     * Please use {@link #readBundle(ClassLoader)} instead (whose data must have
     * been written with {@link #writeBundle}. Read and return a new HashMap object
     * from the parcel at the current dataPosition(), using the given class loader
     * to load any enclosed Parcelables. Returns null if the previously written map
     * object was null.
     */
    public final HashMap readHashMap(ClassLoader loader) {
        return null;
    }

    /**
     * Read and return a new Bundle object from the parcel at the current
     * dataPosition(). Returns null if the previously written Bundle object was
     * null.
     */
    public final Bundle readBundle() {
        return null;
    }

    /**
     * Read and return a new Bundle object from the parcel at the current
     * dataPosition(), using the given class loader to initialize the class loader
     * of the Bundle for later retrieval of Parcelable objects. Returns null if the
     * previously written Bundle object was null.
     */
    public final Bundle readBundle(ClassLoader loader) {
        return null;
    }

    /**
     * Read and return a byte[] object from the parcel.
     */
    public final byte[] createByteArray() {
        return null;
    }

    /**
     * Read a byte[] object from the parcel and copy it into the given byte array.
     */
    public final void readByteArray(byte[] val) {
    }

    /**
     * Read a blob of data from the parcel and return it as a byte array.
     * {@hide} {@SystemApi}
     */
    public final byte[] readBlob() {
        return null;
    }

    /**
     * Read and return a String[] object from the parcel. {@hide}
     */
    public final String[] readStringArray() {
        return null;
    }

    /**
     * Read and return a CharSequence[] object from the parcel. {@hide}
     */
    public final CharSequence[] readCharSequenceArray() {
        return null;
    }

    /**
     * Read and return an ArrayList&lt;CharSequence&gt; object from the parcel.
     * {@hide}
     */
    public final ArrayList<CharSequence> readCharSequenceList() {
        return null;
    }

    /**
     * Read and return a new ArrayList object from the parcel at the current
     * dataPosition(). Returns null if the previously written list object was null.
     * The given class loader will be used to load any enclosed Parcelables.
     */
    public final ArrayList readArrayList(ClassLoader loader) {
        return null;
    }

    /**
     * Read and return a new Object array from the parcel at the current
     * dataPosition(). Returns null if the previously written array was null. The
     * given class loader will be used to load any enclosed Parcelables.
     */
    public final Object[] readArray(ClassLoader loader) {
        return null;
    }

    /**
     * Read and return a new ArrayList containing String objects from the parcel
     * that was written with {@link #writeStringList} at the current dataPosition().
     * Returns null if the previously written list object was null.
     *
     * @return A newly created ArrayList containing strings with the same data as
     *         those that were previously written.
     *
     * @see #writeStringList
     */
    public final ArrayList<String> createStringArrayList() {
        return null;
    }

    /**
     * Read into the given List items String objects that were written with
     * {@link #writeStringList} at the current dataPosition().
     *
     * @see #writeStringList
     */
    public final void readStringList(List<String> list) {
    }

    /**
     * Read a typed object from a parcel. The given class loader will be used to
     * load any enclosed Parcelables. If it is null, the default class loader will
     * be used.
     */
    public final Object readValue(ClassLoader loader) {
        return null;
    }

    /**
     * Read and return a new Parcelable from the parcel. The given class loader will
     * be used to load any enclosed Parcelables. If it is null, the default class
     * loader will be used.
     * 
     * @param loader A ClassLoader from which to instantiate the Parcelable object,
     *               or null for the default class loader.
     * @return Returns the newly created Parcelable, or null if a null object has
     *         been written.
     * @throws BadParcelableException Throws BadParcelableException if there was an
     *                                error trying to instantiate the Parcelable.
     */
    public final <T extends Parcelable> T readParcelable(ClassLoader loader) {
        return null;
    }

    /**
     * Read and return a new Parcelable array from the parcel. The given class
     * loader will be used to load any enclosed Parcelables.
     * 
     * @return the Parcelable array, or null if the array is null
     */
    public final Parcelable[] readParcelableArray(ClassLoader loader) {
        return null;
    }

    /** @hide */
    public final <T extends Parcelable> T[] readParcelableArray(ClassLoader loader, Class<T> clazz) {
        return null;
    }

    /**
     * Read and return a new Serializable object from the parcel.
     * 
     * @return the Serializable object, or null if the Serializable name wasn't
     *         found in the parcel.
     */
    public final Serializable readSerializable() {
        return null;
    }

    private final Serializable readSerializable(final ClassLoader loader) {
        return null;
    }
}
