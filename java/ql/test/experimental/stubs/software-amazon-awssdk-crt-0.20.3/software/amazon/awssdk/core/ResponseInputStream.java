// Generated automatically from software.amazon.awssdk.core.ResponseInputStream for testing purposes

package software.amazon.awssdk.core;

import java.io.InputStream;
import software.amazon.awssdk.core.io.SdkFilterInputStream;
import software.amazon.awssdk.http.Abortable;
import software.amazon.awssdk.http.AbortableInputStream;

public class ResponseInputStream<ResponseT> extends SdkFilterInputStream implements Abortable
{
    protected ResponseInputStream() {}
    public ResponseInputStream(ResponseT p0, AbortableInputStream p1){}
    public ResponseInputStream(ResponseT p0, InputStream p1){}
    public ResponseT response(){ return null; }
    public void abort(){}
}
