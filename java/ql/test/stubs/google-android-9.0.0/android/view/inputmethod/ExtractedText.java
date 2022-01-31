// Generated automatically from android.view.inputmethod.ExtractedText for testing purposes

package android.view.inputmethod;

import android.os.Parcel;
import android.os.Parcelable;

public class ExtractedText implements Parcelable
{
    public CharSequence hint = null;
    public CharSequence text = null;
    public ExtractedText(){}
    public int describeContents(){ return 0; }
    public int flags = 0;
    public int partialEndOffset = 0;
    public int partialStartOffset = 0;
    public int selectionEnd = 0;
    public int selectionStart = 0;
    public int startOffset = 0;
    public static Parcelable.Creator<ExtractedText> CREATOR = null;
    public static int FLAG_SELECTING = 0;
    public static int FLAG_SINGLE_LINE = 0;
    public void writeToParcel(Parcel p0, int p1){}
}
