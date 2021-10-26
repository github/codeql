package com.example.app;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public class ParcelableEntity implements Parcelable {
    private static final Gson GSON = new GsonBuilder().create();

    public ParcelableEntity(Object obj) {
        this.obj = obj;
    }

    private Object obj;

    @Override
    public void writeToParcel(Parcel parcel, int i) {
        parcel.writeString(obj.getClass().getName());
        parcel.writeString(GSON.toJson(obj));
    }

    @Override
    public int describeContents() { return 0; }

    public static final Parcelable.Creator CREATOR = new Creator<ParcelableEntity>() {
        @Override
        public ParcelableEntity createFromParcel(Parcel parcel) {
            try {
                Class clazz = Class.forName(parcel.readString());
                Object obj = GSON.fromJson(parcel.readString(), clazz); // $unsafeDeserialization
                return new ParcelableEntity(obj);
            }
            catch (ClassNotFoundException e) {
                throw new RuntimeException(e);
            }
        }

        @Override
        public ParcelableEntity[] newArray(int size) {
            return new ParcelableEntity[size];
        }
    };
}
