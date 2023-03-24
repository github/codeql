// Generated automatically from android.view.textclassifier.ConversationActions for testing purposes

package android.view.textclassifier;

import android.app.Person;
import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;
import android.view.textclassifier.ConversationAction;
import android.view.textclassifier.TextClassifier;
import java.time.ZonedDateTime;
import java.util.List;

public class ConversationActions implements Parcelable
{
    protected ConversationActions() {}
    public ConversationActions(List<ConversationAction> p0, String p1){}
    public List<ConversationAction> getConversationActions(){ return null; }
    public String getId(){ return null; }
    public int describeContents(){ return 0; }
    public static Parcelable.Creator<ConversationActions> CREATOR = null;
    public void writeToParcel(Parcel p0, int p1){}
    static public class Message implements Parcelable
    {
        protected Message() {}
        public Bundle getExtras(){ return null; }
        public CharSequence getText(){ return null; }
        public Person getAuthor(){ return null; }
        public ZonedDateTime getReferenceTime(){ return null; }
        public int describeContents(){ return 0; }
        public static Parcelable.Creator<ConversationActions.Message> CREATOR = null;
        public static Person PERSON_USER_OTHERS = null;
        public static Person PERSON_USER_SELF = null;
        public void writeToParcel(Parcel p0, int p1){}
    }
    static public class Request implements Parcelable
    {
        protected Request() {}
        public Bundle getExtras(){ return null; }
        public List<ConversationActions.Message> getConversation(){ return null; }
        public List<String> getHints(){ return null; }
        public String getCallingPackageName(){ return null; }
        public TextClassifier.EntityConfig getTypeConfig(){ return null; }
        public int describeContents(){ return 0; }
        public int getMaxSuggestions(){ return 0; }
        public static Parcelable.Creator<ConversationActions.Request> CREATOR = null;
        public static String HINT_FOR_IN_APP = null;
        public static String HINT_FOR_NOTIFICATION = null;
        public void writeToParcel(Parcel p0, int p1){}
    }
}
