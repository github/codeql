// Generated automatically from software.amazon.awssdk.transfer.s3.model.CompletedFileDownload for testing purposes

package software.amazon.awssdk.transfer.s3.model;

import software.amazon.awssdk.services.s3.model.GetObjectResponse;
import software.amazon.awssdk.transfer.s3.model.CompletedObjectTransfer;

public class CompletedFileDownload implements CompletedObjectTransfer
{
    protected CompletedFileDownload() {}
    public GetObjectResponse response(){ return null; }
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public static CompletedFileDownload.Builder builder(){ return null; }
    static public interface Builder
    {
        CompletedFileDownload build();
        CompletedFileDownload.Builder response(GetObjectResponse p0);
    }
}
