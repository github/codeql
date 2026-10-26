// Generated automatically from android.view.textclassifier.TextClassifier for testing purposes

package android.view.textclassifier;

import android.os.LocaleList;
import android.os.Parcel;
import android.os.Parcelable;
import android.view.textclassifier.ConversationActions;
import android.view.textclassifier.SelectionEvent;
import android.view.textclassifier.TextClassification;
import android.view.textclassifier.TextClassifierEvent;
import android.view.textclassifier.TextLanguage;
import android.view.textclassifier.TextLinks;
import android.view.textclassifier.TextSelection;
import java.util.Collection;

public interface TextClassifier
{
    default ConversationActions suggestConversationActions(ConversationActions.Request p0){ return null; }
    default TextClassification classifyText(CharSequence p0, int p1, int p2, LocaleList p3){ return null; }
    default TextClassification classifyText(TextClassification.Request p0){ return null; }
    default TextLanguage detectLanguage(TextLanguage.Request p0){ return null; }
    default TextLinks generateLinks(TextLinks.Request p0){ return null; }
    default TextSelection suggestSelection(CharSequence p0, int p1, int p2, LocaleList p3){ return null; }
    default TextSelection suggestSelection(TextSelection.Request p0){ return null; }
    default boolean isDestroyed(){ return false; }
    default int getMaxGenerateLinksTextLength(){ return 0; }
    default void destroy(){}
    default void onSelectionEvent(SelectionEvent p0){}
    default void onTextClassifierEvent(TextClassifierEvent p0){}
    static String EXTRA_FROM_TEXT_CLASSIFIER = null;
    static String HINT_TEXT_IS_EDITABLE = null;
    static String HINT_TEXT_IS_NOT_EDITABLE = null;
    static String TYPE_ADDRESS = null;
    static String TYPE_DATE = null;
    static String TYPE_DATE_TIME = null;
    static String TYPE_EMAIL = null;
    static String TYPE_FLIGHT_NUMBER = null;
    static String TYPE_OTHER = null;
    static String TYPE_PHONE = null;
    static String TYPE_UNKNOWN = null;
    static String TYPE_URL = null;
    static String WIDGET_TYPE_CLIPBOARD = null;
    static String WIDGET_TYPE_CUSTOM_EDITTEXT = null;
    static String WIDGET_TYPE_CUSTOM_TEXTVIEW = null;
    static String WIDGET_TYPE_CUSTOM_UNSELECTABLE_TEXTVIEW = null;
    static String WIDGET_TYPE_EDITTEXT = null;
    static String WIDGET_TYPE_EDIT_WEBVIEW = null;
    static String WIDGET_TYPE_NOTIFICATION = null;
    static String WIDGET_TYPE_TEXTVIEW = null;
    static String WIDGET_TYPE_UNKNOWN = null;
    static String WIDGET_TYPE_UNSELECTABLE_TEXTVIEW = null;
    static String WIDGET_TYPE_WEBVIEW = null;
    static TextClassifier NO_OP = null;
    static public class EntityConfig implements Parcelable
    {
        protected EntityConfig() {}
        public Collection<String> getHints(){ return null; }
        public Collection<String> resolveEntityListModifications(Collection<String> p0){ return null; }
        public boolean shouldIncludeTypesFromTextClassifier(){ return false; }
        public int describeContents(){ return 0; }
        public static Parcelable.Creator<TextClassifier.EntityConfig> CREATOR = null;
        public static TextClassifier.EntityConfig create(Collection<String> p0, Collection<String> p1, Collection<String> p2){ return null; }
        public static TextClassifier.EntityConfig createWithExplicitEntityList(Collection<String> p0){ return null; }
        public static TextClassifier.EntityConfig createWithHints(Collection<String> p0){ return null; }
        public void writeToParcel(Parcel p0, int p1){}
    }
}
