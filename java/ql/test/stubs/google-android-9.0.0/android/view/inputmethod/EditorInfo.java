// Generated automatically from android.view.inputmethod.EditorInfo for testing purposes

package android.view.inputmethod;

import android.os.Bundle;
import android.os.LocaleList;
import android.os.Parcel;
import android.os.Parcelable;
import android.text.InputType;
import android.util.Printer;
import android.view.inputmethod.SurroundingText;

public class EditorInfo implements InputType, Parcelable
{
    public Bundle extras = null;
    public CharSequence actionLabel = null;
    public CharSequence getInitialSelectedText(int p0){ return null; }
    public CharSequence getInitialTextAfterCursor(int p0, int p1){ return null; }
    public CharSequence getInitialTextBeforeCursor(int p0, int p1){ return null; }
    public CharSequence hintText = null;
    public CharSequence label = null;
    public EditorInfo(){}
    public LocaleList hintLocales = null;
    public String fieldName = null;
    public String packageName = null;
    public String privateImeOptions = null;
    public String[] contentMimeTypes = null;
    public SurroundingText getInitialSurroundingText(int p0, int p1, int p2){ return null; }
    public final void makeCompatible(int p0){}
    public int actionId = 0;
    public int describeContents(){ return 0; }
    public int fieldId = 0;
    public int imeOptions = 0;
    public int initialCapsMode = 0;
    public int initialSelEnd = 0;
    public int initialSelStart = 0;
    public int inputType = 0;
    public static Parcelable.Creator<EditorInfo> CREATOR = null;
    public static int IME_ACTION_DONE = 0;
    public static int IME_ACTION_GO = 0;
    public static int IME_ACTION_NEXT = 0;
    public static int IME_ACTION_NONE = 0;
    public static int IME_ACTION_PREVIOUS = 0;
    public static int IME_ACTION_SEARCH = 0;
    public static int IME_ACTION_SEND = 0;
    public static int IME_ACTION_UNSPECIFIED = 0;
    public static int IME_FLAG_FORCE_ASCII = 0;
    public static int IME_FLAG_NAVIGATE_NEXT = 0;
    public static int IME_FLAG_NAVIGATE_PREVIOUS = 0;
    public static int IME_FLAG_NO_ACCESSORY_ACTION = 0;
    public static int IME_FLAG_NO_ENTER_ACTION = 0;
    public static int IME_FLAG_NO_EXTRACT_UI = 0;
    public static int IME_FLAG_NO_FULLSCREEN = 0;
    public static int IME_FLAG_NO_PERSONALIZED_LEARNING = 0;
    public static int IME_MASK_ACTION = 0;
    public static int IME_NULL = 0;
    public void dump(Printer p0, String p1){}
    public void setInitialSurroundingSubText(CharSequence p0, int p1){}
    public void setInitialSurroundingText(CharSequence p0){}
    public void writeToParcel(Parcel p0, int p1){}
}
