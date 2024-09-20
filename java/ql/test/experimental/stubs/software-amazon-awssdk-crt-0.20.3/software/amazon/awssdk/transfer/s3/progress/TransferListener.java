// Generated automatically from software.amazon.awssdk.transfer.s3.progress.TransferListener for testing purposes

package software.amazon.awssdk.transfer.s3.progress;

import software.amazon.awssdk.transfer.s3.model.CompletedObjectTransfer;
import software.amazon.awssdk.transfer.s3.model.TransferObjectRequest;
import software.amazon.awssdk.transfer.s3.progress.TransferProgressSnapshot;

public interface TransferListener
{
    default void bytesTransferred(TransferListener.Context.BytesTransferred p0){}
    default void transferComplete(TransferListener.Context.TransferComplete p0){}
    default void transferFailed(TransferListener.Context.TransferFailed p0){}
    default void transferInitiated(TransferListener.Context.TransferInitiated p0){}
    static public class Context
    {
        protected Context() {}
        static public interface BytesTransferred extends TransferListener.Context.TransferInitiated
        {
        }
        static public interface TransferComplete extends TransferListener.Context.BytesTransferred
        {
            CompletedObjectTransfer completedTransfer();
        }
        static public interface TransferFailed extends TransferListener.Context.TransferInitiated
        {
            Throwable exception();
        }
        static public interface TransferInitiated
        {
            TransferObjectRequest request();
            TransferProgressSnapshot progressSnapshot();
        }
    }
}
