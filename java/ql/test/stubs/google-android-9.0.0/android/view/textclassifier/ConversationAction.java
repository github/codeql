// Generated automatically from android.view.textclassifier.ConversationAction for testing purposes

package android.view.textclassifier;

import android.app.RemoteAction;
import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;

public class ConversationAction implements Parcelable
{
    protected ConversationAction() {}
    public Bundle getExtras(){ return null; }
    public CharSequence getTextReply(){ return null; }
    public RemoteAction getAction(){ return null; }
    public String getType(){ return null; }
    public float getConfidenceScore(){ return 0; }
    public int describeContents(){ return 0; }
    public static Parcelable.Creator<ConversationAction> CREATOR = null;
    public static String TYPE_CALL_PHONE = null;
    public static String TYPE_CREATE_REMINDER = null;
    public static String TYPE_OPEN_URL = null;
    public static String TYPE_SEND_EMAIL = null;
    public static String TYPE_SEND_SMS = null;
    public static String TYPE_SHARE_LOCATION = null;
    public static String TYPE_TEXT_REPLY = null;
    public static String TYPE_TRACK_FLIGHT = null;
    public static String TYPE_VIEW_CALENDAR = null;
    public static String TYPE_VIEW_MAP = null;
    public void writeToParcel(Parcel p0, int p1){}
}
