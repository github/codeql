// Generated automatically from software.amazon.awssdk.transfer.s3.model.CompletedFileUpload for testing purposes

package software.amazon.awssdk.transfer.s3.model;

import software.amazon.awssdk.services.s3.model.PutObjectResponse;
import software.amazon.awssdk.transfer.s3.model.CompletedObjectTransfer;

public class CompletedFileUpload implements CompletedObjectTransfer
{
    protected CompletedFileUpload() {}
    public PutObjectResponse response(){ return null; }
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public static CompletedFileUpload.Builder builder(){ return null; }
    public static java.lang.Class<? extends CompletedFileUpload.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder
    {
        CompletedFileUpload build();
        CompletedFileUpload.Builder response(PutObjectResponse p0);
    }
}
