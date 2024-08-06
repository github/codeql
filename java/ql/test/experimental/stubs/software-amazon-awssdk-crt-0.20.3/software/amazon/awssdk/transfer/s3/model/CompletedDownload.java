// Generated automatically from software.amazon.awssdk.transfer.s3.model.CompletedDownload for testing purposes

package software.amazon.awssdk.transfer.s3.model;

import software.amazon.awssdk.transfer.s3.model.CompletedObjectTransfer;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class CompletedDownload<ResultT> implements CompletedObjectTransfer, ToCopyableBuilder<CompletedDownload.TypedBuilder<ResultT>, CompletedDownload<ResultT>>
{
    protected CompletedDownload() {}
    public CompletedDownload.TypedBuilder<ResultT> toBuilder(){ return null; }
    public ResultT result(){ return null; }
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public static CompletedDownload.UntypedBuilder builder(){ return null; }
    static public interface TypedBuilder<T> extends CopyableBuilder<CompletedDownload.TypedBuilder<T>, software.amazon.awssdk.transfer.s3.model.CompletedDownload<T>>
    {
        CompletedDownload.TypedBuilder<T> result(T p0);
    }
    static public interface UntypedBuilder
    {
        <T> CompletedDownload.TypedBuilder<T> result(T p0);
    }
}
