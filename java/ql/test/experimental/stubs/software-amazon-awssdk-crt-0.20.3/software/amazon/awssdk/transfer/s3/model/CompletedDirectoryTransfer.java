// Generated automatically from software.amazon.awssdk.transfer.s3.model.CompletedDirectoryTransfer for testing purposes

package software.amazon.awssdk.transfer.s3.model;

import java.util.List;
import software.amazon.awssdk.transfer.s3.model.CompletedTransfer;
import software.amazon.awssdk.transfer.s3.model.FailedObjectTransfer;

public interface CompletedDirectoryTransfer extends CompletedTransfer
{
    List<? extends FailedObjectTransfer> failedTransfers();
}
