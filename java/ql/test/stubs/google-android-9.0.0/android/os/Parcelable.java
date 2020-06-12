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

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

/**
 * Interface for classes whose instances can be written to and restored from a
 * {@link Parcel}. Classes implementing the Parcelable interface must also have
 * a non-null static field called <code>CREATOR</code> of a type that implements
 * the {@link Parcelable.Creator} interface.
 * 
 * <p>
 * A typical implementation of Parcelable is:
 * </p>
 * 
 * <pre>
 * public class MyParcelable implements Parcelable {
 *     private int mData;
 *
 *     public int describeContents() {
 *         return 0;
 *     }
 *
 *     public void writeToParcel(Parcel out, int flags) {
 *         out.writeInt(mData);
 *     }
 *
 *     public static final Parcelable.Creator&lt;MyParcelable&gt; CREATOR = new Parcelable.Creator&lt;MyParcelable&gt;() {
 *         public MyParcelable createFromParcel(Parcel in) {
 *             return new MyParcelable(in);
 *         }
 *
 *         public MyParcelable[] newArray(int size) {
 *             return new MyParcelable[size];
 *         }
 *     };
 * 
 *     private MyParcelable(Parcel in) {
 *         mData = in.readInt();
 *     }
 * }
 * </pre>
 */
public interface Parcelable {
    /**
     * Flatten this object in to a Parcel.
     * 
     * @param dest  The Parcel in which the object should be written.
     * @param flags Additional flags about how the object should be written. May be
     *              0 or {@link #PARCELABLE_WRITE_RETURN_VALUE}.
     */
    public void writeToParcel(Parcel dest, int flags);

    /**
     * Specialization of {@link Creator} that allows you to receive the ClassLoader
     * the object is being created in.
     */
    public interface ClassLoaderCreator<T> {
        /**
         * Create a new instance of the Parcelable class, instantiating it from the
         * given Parcel whose data had previously been written by
         * {@link Parcelable#writeToParcel Parcelable.writeToParcel()} and using the
         * given ClassLoader.
         *
         * @param source The Parcel to read the object's data from.
         * @param loader The ClassLoader that this object is being created in.
         * @return Returns a new instance of the Parcelable class.
         */
        public T createFromParcel(Parcel source, ClassLoader loader);
    }
}