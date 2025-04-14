// Generated automatically from software.amazon.awssdk.transfer.s3.model.Transfer for testing purposes

package software.amazon.awssdk.transfer.s3.model;

import java.util.concurrent.CompletableFuture;
import software.amazon.awssdk.transfer.s3.model.CompletedTransfer;

public interface Transfer
{
    CompletableFuture<? extends CompletedTransfer> completionFuture();
}
