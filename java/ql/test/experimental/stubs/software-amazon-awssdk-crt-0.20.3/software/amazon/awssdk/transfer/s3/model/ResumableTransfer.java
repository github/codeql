// Generated automatically from software.amazon.awssdk.transfer.s3.model.ResumableTransfer for testing purposes

package software.amazon.awssdk.transfer.s3.model;

import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Path;
import software.amazon.awssdk.core.SdkBytes;

public interface ResumableTransfer
{
    default InputStream serializeToInputStream(){ return null; }
    default SdkBytes serializeToBytes(){ return null; }
    default String serializeToString(){ return null; }
    default void serializeToFile(Path p0){}
    default void serializeToOutputStream(OutputStream p0){}
}
