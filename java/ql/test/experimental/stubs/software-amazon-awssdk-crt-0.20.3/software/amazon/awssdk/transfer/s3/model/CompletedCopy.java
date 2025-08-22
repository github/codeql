// Generated automatically from software.amazon.awssdk.transfer.s3.model.CompletedCopy for testing purposes

package software.amazon.awssdk.transfer.s3.model;

import software.amazon.awssdk.services.s3.model.CopyObjectResponse;
import software.amazon.awssdk.transfer.s3.model.CompletedObjectTransfer;

public class CompletedCopy implements CompletedObjectTransfer
{
    protected CompletedCopy() {}
    public CopyObjectResponse response(){ return null; }
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public static CompletedCopy.Builder builder(){ return null; }
    public static java.lang.Class<? extends CompletedCopy.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder
    {
        CompletedCopy build();
        CompletedCopy.Builder response(CopyObjectResponse p0);
    }
}
