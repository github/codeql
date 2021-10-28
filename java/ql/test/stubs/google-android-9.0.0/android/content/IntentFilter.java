// Generated automatically from android.content.IntentFilter for testing purposes

package android.content;

import android.content.ContentResolver;
import android.content.Intent;
import android.net.Uri;
import android.os.Parcel;
import android.os.Parcelable;
import android.os.PatternMatcher;
import android.util.AndroidException;
import android.util.Printer;
import java.util.Iterator;
import java.util.Set;
import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlSerializer;

public class IntentFilter implements Parcelable
{
    public IntentFilter(){}
    public IntentFilter(IntentFilter p0){}
    public IntentFilter(String p0){}
    public IntentFilter(String p0, String p1){}
    public final IntentFilter.AuthorityEntry getDataAuthority(int p0){ return null; }
    public final Iterator<IntentFilter.AuthorityEntry> authoritiesIterator(){ return null; }
    public final Iterator<PatternMatcher> pathsIterator(){ return null; }
    public final Iterator<PatternMatcher> schemeSpecificPartsIterator(){ return null; }
    public final Iterator<String> actionsIterator(){ return null; }
    public final Iterator<String> categoriesIterator(){ return null; }
    public final Iterator<String> schemesIterator(){ return null; }
    public final Iterator<String> typesIterator(){ return null; }
    public final PatternMatcher getDataPath(int p0){ return null; }
    public final PatternMatcher getDataSchemeSpecificPart(int p0){ return null; }
    public final String getAction(int p0){ return null; }
    public final String getCategory(int p0){ return null; }
    public final String getDataScheme(int p0){ return null; }
    public final String getDataType(int p0){ return null; }
    public final String matchCategories(Set<String> p0){ return null; }
    public final boolean hasAction(String p0){ return false; }
    public final boolean hasCategory(String p0){ return false; }
    public final boolean hasDataAuthority(Uri p0){ return false; }
    public final boolean hasDataPath(String p0){ return false; }
    public final boolean hasDataScheme(String p0){ return false; }
    public final boolean hasDataSchemeSpecificPart(String p0){ return false; }
    public final boolean hasDataType(String p0){ return false; }
    public final boolean matchAction(String p0){ return false; }
    public final int countActions(){ return 0; }
    public final int countCategories(){ return 0; }
    public final int countDataAuthorities(){ return 0; }
    public final int countDataPaths(){ return 0; }
    public final int countDataSchemeSpecificParts(){ return 0; }
    public final int countDataSchemes(){ return 0; }
    public final int countDataTypes(){ return 0; }
    public final int describeContents(){ return 0; }
    public final int getPriority(){ return 0; }
    public final int match(ContentResolver p0, Intent p1, boolean p2, String p3){ return 0; }
    public final int match(String p0, String p1, String p2, Uri p3, Set<String> p4, String p5){ return 0; }
    public final int matchData(String p0, String p1, Uri p2){ return 0; }
    public final int matchDataAuthority(Uri p0){ return 0; }
    public final void addAction(String p0){}
    public final void addCategory(String p0){}
    public final void addDataAuthority(String p0, String p1){}
    public final void addDataPath(String p0, int p1){}
    public final void addDataScheme(String p0){}
    public final void addDataSchemeSpecificPart(String p0, int p1){}
    public final void addDataType(String p0){}
    public final void setPriority(int p0){}
    public final void writeToParcel(Parcel p0, int p1){}
    public static IntentFilter create(String p0, String p1){ return null; }
    public static Parcelable.Creator<IntentFilter> CREATOR = null;
    public static int MATCH_ADJUSTMENT_MASK = 0;
    public static int MATCH_ADJUSTMENT_NORMAL = 0;
    public static int MATCH_CATEGORY_EMPTY = 0;
    public static int MATCH_CATEGORY_HOST = 0;
    public static int MATCH_CATEGORY_MASK = 0;
    public static int MATCH_CATEGORY_PATH = 0;
    public static int MATCH_CATEGORY_PORT = 0;
    public static int MATCH_CATEGORY_SCHEME = 0;
    public static int MATCH_CATEGORY_SCHEME_SPECIFIC_PART = 0;
    public static int MATCH_CATEGORY_TYPE = 0;
    public static int NO_MATCH_ACTION = 0;
    public static int NO_MATCH_CATEGORY = 0;
    public static int NO_MATCH_DATA = 0;
    public static int NO_MATCH_TYPE = 0;
    public static int SYSTEM_HIGH_PRIORITY = 0;
    public static int SYSTEM_LOW_PRIORITY = 0;
    public void dump(Printer p0, String p1){}
    public void readFromXml(XmlPullParser p0){}
    public void writeToXml(XmlSerializer p0){}
    static public class AuthorityEntry
    {
        protected AuthorityEntry() {}
        public AuthorityEntry(String p0, String p1){}
        public String getHost(){ return null; }
        public boolean equals(Object p0){ return false; }
        public int getPort(){ return 0; }
        public int match(Uri p0){ return 0; }
    }
    static public class MalformedMimeTypeException extends AndroidException
    {
        public MalformedMimeTypeException(){}
        public MalformedMimeTypeException(String p0){}
    }
}
