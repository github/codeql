// Generated automatically from android.os.Parcelable for testing purposes

package android.os;

import android.os.Parcel;

public interface Parcelable
{
    int describeContents();
    static int CONTENTS_FILE_DESCRIPTOR = 0;
    static int PARCELABLE_WRITE_RETURN_VALUE = 0;
    static public interface Creator<T>
    {
        T createFromParcel(Parcel p0);
        T[] newArray(int p0);
    }
    void writeToParcel(Parcel p0, int p1);
}
