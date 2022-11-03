/*
 * Copyright (C) 2007 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License
 * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing permissions and limitations under
 * the License.
 */

package android.content;

import android.annotation.Nullable;
import android.os.Parcel;
import android.os.Parcelable;
import android.util.ArrayMap;
import java.util.ArrayList;
import java.util.Map;
import java.util.Set;

public final class ContentValues implements Parcelable {
    public ContentValues() {}

    public ContentValues(int size) {}

    public ContentValues(ContentValues from) {}

    @Override
    public boolean equals(Object object) {
        return false;
    }

    public ArrayMap<String, Object> getValues() {
        return null;
    }

    @Override
    public int hashCode() {
        return 0;
    }

    public void put(String key, String value) {}

    public void putAll(ContentValues other) {}

    public void put(String key, Byte value) {}

    public void put(String key, Short value) {}

    public void put(String key, Integer value) {}

    public void put(String key, Long value) {}

    public void put(String key, Float value) {}

    public void put(String key, Double value) {}

    public void put(String key, Boolean value) {}

    public void put(String key, byte[] value) {}

    public void putNull(String key) {}

    public void putObject(@Nullable String key, @Nullable Object value) {}

    public int size() {
        return 0;
    }

    public boolean isEmpty() {
        return false;
    }

    public void remove(String key) {}

    public void clear() {}

    public boolean containsKey(String key) {
        return false;
    }

    public Object get(String key) {
        return null;
    }

    public String getAsString(String key) {
        return null;
    }

    public Long getAsLong(String key) {
        return null;
    }

    public Integer getAsInteger(String key) {
        return null;
    }

    public Short getAsShort(String key) {
        return null;
    }

    public Byte getAsByte(String key) {
        return null;
    }

    public Double getAsDouble(String key) {
        return null;
    }

    public Float getAsFloat(String key) {
        return null;
    }

    public Boolean getAsBoolean(String key) {
        return null;
    }

    public byte[] getAsByteArray(String key) {
        return null;
    }

    public Set<Map.Entry<String, Object>> valueSet() {
        return null;
    }

    public Set<String> keySet() {
        return null;
    }

    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel parcel, int flags) {}

    public void putStringArrayList(String key, ArrayList<String> value) {}

    public ArrayList<String> getStringArrayList(String key) {
        return null;
    }

    @Override
    public String toString() {
        return null;
    }

    public static boolean isSupportedValue(Object value) {
        return false;
    }

}
