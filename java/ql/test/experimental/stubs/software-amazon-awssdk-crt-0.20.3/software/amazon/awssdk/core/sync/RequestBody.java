// Generated automatically from software.amazon.awssdk.core.sync.RequestBody for testing purposes

package software.amazon.awssdk.core.sync;

import java.io.File;
import java.io.InputStream;
import java.nio.ByteBuffer;
import java.nio.charset.Charset;
import java.nio.file.Path;
import java.util.Optional;
import software.amazon.awssdk.http.ContentStreamProvider;

public class RequestBody
{
    protected RequestBody() {}
    public ContentStreamProvider contentStreamProvider(){ return null; }
    public Optional<Long> optionalContentLength(){ return null; }
    public String contentType(){ return null; }
    public long contentLength(){ return 0; }
    public static RequestBody empty(){ return null; }
    public static RequestBody fromByteBuffer(ByteBuffer p0){ return null; }
    public static RequestBody fromBytes(byte[] p0){ return null; }
    public static RequestBody fromContentProvider(ContentStreamProvider p0, String p1){ return null; }
    public static RequestBody fromContentProvider(ContentStreamProvider p0, long p1, String p2){ return null; }
    public static RequestBody fromFile(File p0){ return null; }
    public static RequestBody fromFile(Path p0){ return null; }
    public static RequestBody fromInputStream(InputStream p0, long p1){ return null; }
    public static RequestBody fromRemainingByteBuffer(ByteBuffer p0){ return null; }
    public static RequestBody fromString(String p0){ return null; }
    public static RequestBody fromString(String p0, Charset p1){ return null; }
}
