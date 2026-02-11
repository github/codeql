// Generated automatically from software.amazon.awssdk.transfer.s3.model.Copy for testing purposes

package software.amazon.awssdk.transfer.s3.model;

import java.util.concurrent.CompletableFuture;
import software.amazon.awssdk.transfer.s3.model.CompletedCopy;
import software.amazon.awssdk.transfer.s3.model.ObjectTransfer;

public interface Copy extends ObjectTransfer
{
    CompletableFuture<CompletedCopy> completionFuture();
}
