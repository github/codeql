// Generated automatically from software.amazon.awssdk.transfer.s3.model.CopyRequest for testing purposes

package software.amazon.awssdk.transfer.s3.model;

import java.util.Collection;
import java.util.List;
import java.util.function.Consumer;
import software.amazon.awssdk.services.s3.model.CopyObjectRequest;
import software.amazon.awssdk.transfer.s3.model.TransferObjectRequest;
import software.amazon.awssdk.transfer.s3.progress.TransferListener;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class CopyRequest implements ToCopyableBuilder<CopyRequest.Builder, CopyRequest>, TransferObjectRequest
{
    protected CopyRequest() {}
    public CopyObjectRequest copyObjectRequest(){ return null; }
    public CopyRequest.Builder toBuilder(){ return null; }
    public List<TransferListener> transferListeners(){ return null; }
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public static CopyRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends CopyRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<CopyRequest.Builder, CopyRequest>
    {
        CopyRequest build();
        CopyRequest.Builder addTransferListener(TransferListener p0);
        CopyRequest.Builder copyObjectRequest(CopyObjectRequest p0);
        CopyRequest.Builder transferListeners(Collection<TransferListener> p0);
        default CopyRequest.Builder copyObjectRequest(java.util.function.Consumer<CopyObjectRequest.Builder> p0){ return null; }
    }
}
