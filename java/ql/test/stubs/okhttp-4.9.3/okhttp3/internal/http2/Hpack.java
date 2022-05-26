// Generated automatically from okhttp3.internal.http2.Hpack for testing purposes

package okhttp3.internal.http2;

import java.util.List;
import java.util.Map;
import okhttp3.internal.http2.Header;
import okio.Buffer;
import okio.ByteString;

public class Hpack
{
    protected Hpack() {}
    public final ByteString checkLowercase(ByteString p0){ return null; }
    public final Header[] getSTATIC_HEADER_TABLE(){ return null; }
    public final Map<ByteString, Integer> getNAME_TO_FIRST_INDEX(){ return null; }
    public static Hpack INSTANCE = null;
    static public class Writer
    {
        protected Writer() {}
        public Header[] dynamicTable = null;
        public Writer(Buffer p0){}
        public Writer(int p0, Buffer p1){}
        public Writer(int p0, boolean p1, Buffer p2){}
        public final void resizeHeaderTable(int p0){}
        public final void writeByteString(ByteString p0){}
        public final void writeHeaders(List<Header> p0){}
        public final void writeInt(int p0, int p1, int p2){}
        public int dynamicTableByteCount = 0;
        public int headerCount = 0;
        public int headerTableSizeSetting = 0;
        public int maxDynamicTableByteCount = 0;
    }
}
