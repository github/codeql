// Generated automatically from software.amazon.awssdk.transfer.s3.progress.LoggingTransferListener for testing purposes

package software.amazon.awssdk.transfer.s3.progress;

import software.amazon.awssdk.transfer.s3.progress.TransferListener;

public class LoggingTransferListener implements TransferListener
{
    protected LoggingTransferListener() {}
    public static LoggingTransferListener create(){ return null; }
    public static LoggingTransferListener create(int p0){ return null; }
    public void bytesTransferred(TransferListener.Context.BytesTransferred p0){}
    public void transferComplete(TransferListener.Context.TransferComplete p0){}
    public void transferFailed(TransferListener.Context.TransferFailed p0){}
    public void transferInitiated(TransferListener.Context.TransferInitiated p0){}
}
