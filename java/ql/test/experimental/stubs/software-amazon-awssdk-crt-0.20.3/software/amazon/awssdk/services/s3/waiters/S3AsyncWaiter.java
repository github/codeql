// Generated automatically from software.amazon.awssdk.services.s3.waiters.S3AsyncWaiter for testing purposes

package software.amazon.awssdk.services.s3.waiters;

import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ScheduledExecutorService;
import java.util.function.Consumer;
import software.amazon.awssdk.core.waiters.WaiterOverrideConfiguration;
import software.amazon.awssdk.core.waiters.WaiterResponse;
import software.amazon.awssdk.services.s3.S3AsyncClient;
import software.amazon.awssdk.services.s3.model.HeadBucketRequest;
import software.amazon.awssdk.services.s3.model.HeadBucketResponse;
import software.amazon.awssdk.services.s3.model.HeadObjectRequest;
import software.amazon.awssdk.services.s3.model.HeadObjectResponse;
import software.amazon.awssdk.utils.SdkAutoCloseable;

public interface S3AsyncWaiter extends SdkAutoCloseable
{
    default CompletableFuture<WaiterResponse<HeadBucketResponse>> waitUntilBucketExists(HeadBucketRequest p0){ return null; }
    default CompletableFuture<WaiterResponse<HeadBucketResponse>> waitUntilBucketExists(HeadBucketRequest p0, WaiterOverrideConfiguration p1){ return null; }
    default CompletableFuture<WaiterResponse<HeadBucketResponse>> waitUntilBucketExists(java.util.function.Consumer<HeadBucketRequest.Builder> p0){ return null; }
    default CompletableFuture<WaiterResponse<HeadBucketResponse>> waitUntilBucketExists(java.util.function.Consumer<HeadBucketRequest.Builder> p0, java.util.function.Consumer<WaiterOverrideConfiguration.Builder> p1){ return null; }
    default CompletableFuture<WaiterResponse<HeadBucketResponse>> waitUntilBucketNotExists(HeadBucketRequest p0){ return null; }
    default CompletableFuture<WaiterResponse<HeadBucketResponse>> waitUntilBucketNotExists(HeadBucketRequest p0, WaiterOverrideConfiguration p1){ return null; }
    default CompletableFuture<WaiterResponse<HeadBucketResponse>> waitUntilBucketNotExists(java.util.function.Consumer<HeadBucketRequest.Builder> p0){ return null; }
    default CompletableFuture<WaiterResponse<HeadBucketResponse>> waitUntilBucketNotExists(java.util.function.Consumer<HeadBucketRequest.Builder> p0, java.util.function.Consumer<WaiterOverrideConfiguration.Builder> p1){ return null; }
    default CompletableFuture<WaiterResponse<HeadObjectResponse>> waitUntilObjectExists(HeadObjectRequest p0){ return null; }
    default CompletableFuture<WaiterResponse<HeadObjectResponse>> waitUntilObjectExists(HeadObjectRequest p0, WaiterOverrideConfiguration p1){ return null; }
    default CompletableFuture<WaiterResponse<HeadObjectResponse>> waitUntilObjectExists(java.util.function.Consumer<HeadObjectRequest.Builder> p0){ return null; }
    default CompletableFuture<WaiterResponse<HeadObjectResponse>> waitUntilObjectExists(java.util.function.Consumer<HeadObjectRequest.Builder> p0, java.util.function.Consumer<WaiterOverrideConfiguration.Builder> p1){ return null; }
    default CompletableFuture<WaiterResponse<HeadObjectResponse>> waitUntilObjectNotExists(HeadObjectRequest p0){ return null; }
    default CompletableFuture<WaiterResponse<HeadObjectResponse>> waitUntilObjectNotExists(HeadObjectRequest p0, WaiterOverrideConfiguration p1){ return null; }
    default CompletableFuture<WaiterResponse<HeadObjectResponse>> waitUntilObjectNotExists(java.util.function.Consumer<HeadObjectRequest.Builder> p0){ return null; }
    default CompletableFuture<WaiterResponse<HeadObjectResponse>> waitUntilObjectNotExists(java.util.function.Consumer<HeadObjectRequest.Builder> p0, java.util.function.Consumer<WaiterOverrideConfiguration.Builder> p1){ return null; }
    static S3AsyncWaiter create(){ return null; }
    static S3AsyncWaiter.Builder builder(){ return null; }
    static public interface Builder
    {
        S3AsyncWaiter build();
        S3AsyncWaiter.Builder client(S3AsyncClient p0);
        S3AsyncWaiter.Builder overrideConfiguration(WaiterOverrideConfiguration p0);
        S3AsyncWaiter.Builder scheduledExecutorService(ScheduledExecutorService p0);
        default S3AsyncWaiter.Builder overrideConfiguration(java.util.function.Consumer<WaiterOverrideConfiguration.Builder> p0){ return null; }
    }
}
