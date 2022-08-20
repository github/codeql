// Generated automatically from android.view.translation.TranslationCapability for testing purposes

package android.view.translation;

import android.os.Parcel;
import android.os.Parcelable;
import android.view.translation.TranslationSpec;

public class TranslationCapability implements Parcelable
{
    public String toString(){ return null; }
    public TranslationSpec getSourceSpec(){ return null; }
    public TranslationSpec getTargetSpec(){ return null; }
    public boolean isUiTranslationEnabled(){ return false; }
    public int describeContents(){ return 0; }
    public int getState(){ return 0; }
    public int getSupportedTranslationFlags(){ return 0; }
    public static Parcelable.Creator<TranslationCapability> CREATOR = null;
    public static int STATE_AVAILABLE_TO_DOWNLOAD = 0;
    public static int STATE_DOWNLOADING = 0;
    public static int STATE_NOT_AVAILABLE = 0;
    public static int STATE_ON_DEVICE = 0;
    public void writeToParcel(Parcel p0, int p1){}
}
