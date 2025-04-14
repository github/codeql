// Generated automatically from software.amazon.awssdk.core.async.AsyncResponseTransformer for testing purposes

package software.amazon.awssdk.core.async;

import java.io.File;
import java.nio.ByteBuffer;
import java.nio.file.Path;
import java.util.concurrent.CompletableFuture;
import java.util.function.Consumer;
import software.amazon.awssdk.core.FileTransformerConfiguration;
import software.amazon.awssdk.core.ResponseBytes;
import software.amazon.awssdk.core.ResponseInputStream;
import software.amazon.awssdk.core.SdkResponse;
import software.amazon.awssdk.core.async.ResponsePublisher;
import software.amazon.awssdk.core.async.SdkPublisher;

public interface AsyncResponseTransformer<ResponseT, ResultT>
{
    CompletableFuture<ResultT> prepare();
    static <ResponseT extends SdkResponse> AsyncResponseTransformer<ResponseT, ResponseInputStream<ResponseT>> toBlockingInputStream(){ return null; }
    static <ResponseT extends SdkResponse> AsyncResponseTransformer<ResponseT, ResponsePublisher<ResponseT>> toPublisher(){ return null; }
    static <ResponseT> AsyncResponseTransformer<ResponseT, software.amazon.awssdk.core.ResponseBytes<ResponseT>> toBytes(){ return null; }
    static <ResponseT> software.amazon.awssdk.core.async.AsyncResponseTransformer<ResponseT, ResponseT> toFile(File p0){ return null; }
    static <ResponseT> software.amazon.awssdk.core.async.AsyncResponseTransformer<ResponseT, ResponseT> toFile(File p0, FileTransformerConfiguration p1){ return null; }
    static <ResponseT> software.amazon.awssdk.core.async.AsyncResponseTransformer<ResponseT, ResponseT> toFile(File p0, java.util.function.Consumer<FileTransformerConfiguration.Builder> p1){ return null; }
    static <ResponseT> software.amazon.awssdk.core.async.AsyncResponseTransformer<ResponseT, ResponseT> toFile(Path p0){ return null; }
    static <ResponseT> software.amazon.awssdk.core.async.AsyncResponseTransformer<ResponseT, ResponseT> toFile(Path p0, FileTransformerConfiguration p1){ return null; }
    static <ResponseT> software.amazon.awssdk.core.async.AsyncResponseTransformer<ResponseT, ResponseT> toFile(Path p0, java.util.function.Consumer<FileTransformerConfiguration.Builder> p1){ return null; }
    void exceptionOccurred(Throwable p0);
    void onResponse(ResponseT p0);
    void onStream(SdkPublisher<ByteBuffer> p0);
}
