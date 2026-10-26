// Generated automatically from android.view.WindowId for testing purposes

package android.view;

import android.os.Parcel;
import android.os.Parcelable;

public class WindowId implements Parcelable
{
    abstract static public class FocusObserver
    {
        public FocusObserver(){}
        public abstract void onFocusGained(WindowId p0);
        public abstract void onFocusLost(WindowId p0);
    }
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean isFocused(){ return false; }
    public int describeContents(){ return 0; }
    public int hashCode(){ return 0; }
    public static Parcelable.Creator<WindowId> CREATOR = null;
    public void registerFocusObserver(WindowId.FocusObserver p0){}
    public void unregisterFocusObserver(WindowId.FocusObserver p0){}
    public void writeToParcel(Parcel p0, int p1){}
}
