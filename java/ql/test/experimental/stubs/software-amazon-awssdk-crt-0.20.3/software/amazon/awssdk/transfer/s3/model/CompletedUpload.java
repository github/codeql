// Generated automatically from software.amazon.awssdk.transfer.s3.model.CompletedUpload for testing purposes

package software.amazon.awssdk.transfer.s3.model;

import software.amazon.awssdk.services.s3.model.PutObjectResponse;
import software.amazon.awssdk.transfer.s3.model.CompletedObjectTransfer;

public class CompletedUpload implements CompletedObjectTransfer
{
    protected CompletedUpload() {}
    public PutObjectResponse response(){ return null; }
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public static CompletedUpload.Builder builder(){ return null; }
    public static java.lang.Class<? extends CompletedUpload.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder
    {
        CompletedUpload build();
        CompletedUpload.Builder response(PutObjectResponse p0);
    }
}
