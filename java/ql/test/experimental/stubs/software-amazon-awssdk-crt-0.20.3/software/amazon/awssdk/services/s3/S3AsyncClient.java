// Generated automatically from software.amazon.awssdk.services.s3.S3AsyncClient for testing purposes

package software.amazon.awssdk.services.s3;

import java.nio.file.Path;
import java.util.concurrent.CompletableFuture;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkClient;
import software.amazon.awssdk.core.async.AsyncRequestBody;
import software.amazon.awssdk.core.async.AsyncResponseTransformer;
import software.amazon.awssdk.services.s3.S3AsyncClientBuilder;
import software.amazon.awssdk.services.s3.S3CrtAsyncClientBuilder;
import software.amazon.awssdk.services.s3.S3Utilities;
import software.amazon.awssdk.services.s3.model.AbortMultipartUploadRequest;
import software.amazon.awssdk.services.s3.model.AbortMultipartUploadResponse;
import software.amazon.awssdk.services.s3.model.CompleteMultipartUploadRequest;
import software.amazon.awssdk.services.s3.model.CompleteMultipartUploadResponse;
import software.amazon.awssdk.services.s3.model.CopyObjectRequest;
import software.amazon.awssdk.services.s3.model.CopyObjectResponse;
import software.amazon.awssdk.services.s3.model.CreateBucketRequest;
import software.amazon.awssdk.services.s3.model.CreateBucketResponse;
import software.amazon.awssdk.services.s3.model.CreateMultipartUploadRequest;
import software.amazon.awssdk.services.s3.model.CreateMultipartUploadResponse;
import software.amazon.awssdk.services.s3.model.DeleteBucketAnalyticsConfigurationRequest;
import software.amazon.awssdk.services.s3.model.DeleteBucketAnalyticsConfigurationResponse;
import software.amazon.awssdk.services.s3.model.DeleteBucketCorsRequest;
import software.amazon.awssdk.services.s3.model.DeleteBucketCorsResponse;
import software.amazon.awssdk.services.s3.model.DeleteBucketEncryptionRequest;
import software.amazon.awssdk.services.s3.model.DeleteBucketEncryptionResponse;
import software.amazon.awssdk.services.s3.model.DeleteBucketIntelligentTieringConfigurationRequest;
import software.amazon.awssdk.services.s3.model.DeleteBucketIntelligentTieringConfigurationResponse;
import software.amazon.awssdk.services.s3.model.DeleteBucketInventoryConfigurationRequest;
import software.amazon.awssdk.services.s3.model.DeleteBucketInventoryConfigurationResponse;
import software.amazon.awssdk.services.s3.model.DeleteBucketLifecycleRequest;
import software.amazon.awssdk.services.s3.model.DeleteBucketLifecycleResponse;
import software.amazon.awssdk.services.s3.model.DeleteBucketMetricsConfigurationRequest;
import software.amazon.awssdk.services.s3.model.DeleteBucketMetricsConfigurationResponse;
import software.amazon.awssdk.services.s3.model.DeleteBucketOwnershipControlsRequest;
import software.amazon.awssdk.services.s3.model.DeleteBucketOwnershipControlsResponse;
import software.amazon.awssdk.services.s3.model.DeleteBucketPolicyRequest;
import software.amazon.awssdk.services.s3.model.DeleteBucketPolicyResponse;
import software.amazon.awssdk.services.s3.model.DeleteBucketReplicationRequest;
import software.amazon.awssdk.services.s3.model.DeleteBucketReplicationResponse;
import software.amazon.awssdk.services.s3.model.DeleteBucketRequest;
import software.amazon.awssdk.services.s3.model.DeleteBucketResponse;
import software.amazon.awssdk.services.s3.model.DeleteBucketTaggingRequest;
import software.amazon.awssdk.services.s3.model.DeleteBucketTaggingResponse;
import software.amazon.awssdk.services.s3.model.DeleteBucketWebsiteRequest;
import software.amazon.awssdk.services.s3.model.DeleteBucketWebsiteResponse;
import software.amazon.awssdk.services.s3.model.DeleteObjectRequest;
import software.amazon.awssdk.services.s3.model.DeleteObjectResponse;
import software.amazon.awssdk.services.s3.model.DeleteObjectTaggingRequest;
import software.amazon.awssdk.services.s3.model.DeleteObjectTaggingResponse;
import software.amazon.awssdk.services.s3.model.DeleteObjectsRequest;
import software.amazon.awssdk.services.s3.model.DeleteObjectsResponse;
import software.amazon.awssdk.services.s3.model.DeletePublicAccessBlockRequest;
import software.amazon.awssdk.services.s3.model.DeletePublicAccessBlockResponse;
import software.amazon.awssdk.services.s3.model.GetBucketAccelerateConfigurationRequest;
import software.amazon.awssdk.services.s3.model.GetBucketAccelerateConfigurationResponse;
import software.amazon.awssdk.services.s3.model.GetBucketAclRequest;
import software.amazon.awssdk.services.s3.model.GetBucketAclResponse;
import software.amazon.awssdk.services.s3.model.GetBucketAnalyticsConfigurationRequest;
import software.amazon.awssdk.services.s3.model.GetBucketAnalyticsConfigurationResponse;
import software.amazon.awssdk.services.s3.model.GetBucketCorsRequest;
import software.amazon.awssdk.services.s3.model.GetBucketCorsResponse;
import software.amazon.awssdk.services.s3.model.GetBucketEncryptionRequest;
import software.amazon.awssdk.services.s3.model.GetBucketEncryptionResponse;
import software.amazon.awssdk.services.s3.model.GetBucketIntelligentTieringConfigurationRequest;
import software.amazon.awssdk.services.s3.model.GetBucketIntelligentTieringConfigurationResponse;
import software.amazon.awssdk.services.s3.model.GetBucketInventoryConfigurationRequest;
import software.amazon.awssdk.services.s3.model.GetBucketInventoryConfigurationResponse;
import software.amazon.awssdk.services.s3.model.GetBucketLifecycleConfigurationRequest;
import software.amazon.awssdk.services.s3.model.GetBucketLifecycleConfigurationResponse;
import software.amazon.awssdk.services.s3.model.GetBucketLocationRequest;
import software.amazon.awssdk.services.s3.model.GetBucketLocationResponse;
import software.amazon.awssdk.services.s3.model.GetBucketLoggingRequest;
import software.amazon.awssdk.services.s3.model.GetBucketLoggingResponse;
import software.amazon.awssdk.services.s3.model.GetBucketMetricsConfigurationRequest;
import software.amazon.awssdk.services.s3.model.GetBucketMetricsConfigurationResponse;
import software.amazon.awssdk.services.s3.model.GetBucketNotificationConfigurationRequest;
import software.amazon.awssdk.services.s3.model.GetBucketNotificationConfigurationResponse;
import software.amazon.awssdk.services.s3.model.GetBucketOwnershipControlsRequest;
import software.amazon.awssdk.services.s3.model.GetBucketOwnershipControlsResponse;
import software.amazon.awssdk.services.s3.model.GetBucketPolicyRequest;
import software.amazon.awssdk.services.s3.model.GetBucketPolicyResponse;
import software.amazon.awssdk.services.s3.model.GetBucketPolicyStatusRequest;
import software.amazon.awssdk.services.s3.model.GetBucketPolicyStatusResponse;
import software.amazon.awssdk.services.s3.model.GetBucketReplicationRequest;
import software.amazon.awssdk.services.s3.model.GetBucketReplicationResponse;
import software.amazon.awssdk.services.s3.model.GetBucketRequestPaymentRequest;
import software.amazon.awssdk.services.s3.model.GetBucketRequestPaymentResponse;
import software.amazon.awssdk.services.s3.model.GetBucketTaggingRequest;
import software.amazon.awssdk.services.s3.model.GetBucketTaggingResponse;
import software.amazon.awssdk.services.s3.model.GetBucketVersioningRequest;
import software.amazon.awssdk.services.s3.model.GetBucketVersioningResponse;
import software.amazon.awssdk.services.s3.model.GetBucketWebsiteRequest;
import software.amazon.awssdk.services.s3.model.GetBucketWebsiteResponse;
import software.amazon.awssdk.services.s3.model.GetObjectAclRequest;
import software.amazon.awssdk.services.s3.model.GetObjectAclResponse;
import software.amazon.awssdk.services.s3.model.GetObjectAttributesRequest;
import software.amazon.awssdk.services.s3.model.GetObjectAttributesResponse;
import software.amazon.awssdk.services.s3.model.GetObjectLegalHoldRequest;
import software.amazon.awssdk.services.s3.model.GetObjectLegalHoldResponse;
import software.amazon.awssdk.services.s3.model.GetObjectLockConfigurationRequest;
import software.amazon.awssdk.services.s3.model.GetObjectLockConfigurationResponse;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;
import software.amazon.awssdk.services.s3.model.GetObjectResponse;
import software.amazon.awssdk.services.s3.model.GetObjectRetentionRequest;
import software.amazon.awssdk.services.s3.model.GetObjectRetentionResponse;
import software.amazon.awssdk.services.s3.model.GetObjectTaggingRequest;
import software.amazon.awssdk.services.s3.model.GetObjectTaggingResponse;
import software.amazon.awssdk.services.s3.model.GetObjectTorrentRequest;
import software.amazon.awssdk.services.s3.model.GetObjectTorrentResponse;
import software.amazon.awssdk.services.s3.model.GetPublicAccessBlockRequest;
import software.amazon.awssdk.services.s3.model.GetPublicAccessBlockResponse;
import software.amazon.awssdk.services.s3.model.HeadBucketRequest;
import software.amazon.awssdk.services.s3.model.HeadBucketResponse;
import software.amazon.awssdk.services.s3.model.HeadObjectRequest;
import software.amazon.awssdk.services.s3.model.HeadObjectResponse;
import software.amazon.awssdk.services.s3.model.ListBucketAnalyticsConfigurationsRequest;
import software.amazon.awssdk.services.s3.model.ListBucketAnalyticsConfigurationsResponse;
import software.amazon.awssdk.services.s3.model.ListBucketIntelligentTieringConfigurationsRequest;
import software.amazon.awssdk.services.s3.model.ListBucketIntelligentTieringConfigurationsResponse;
import software.amazon.awssdk.services.s3.model.ListBucketInventoryConfigurationsRequest;
import software.amazon.awssdk.services.s3.model.ListBucketInventoryConfigurationsResponse;
import software.amazon.awssdk.services.s3.model.ListBucketMetricsConfigurationsRequest;
import software.amazon.awssdk.services.s3.model.ListBucketMetricsConfigurationsResponse;
import software.amazon.awssdk.services.s3.model.ListBucketsRequest;
import software.amazon.awssdk.services.s3.model.ListBucketsResponse;
import software.amazon.awssdk.services.s3.model.ListMultipartUploadsRequest;
import software.amazon.awssdk.services.s3.model.ListMultipartUploadsResponse;
import software.amazon.awssdk.services.s3.model.ListObjectVersionsRequest;
import software.amazon.awssdk.services.s3.model.ListObjectVersionsResponse;
import software.amazon.awssdk.services.s3.model.ListObjectsRequest;
import software.amazon.awssdk.services.s3.model.ListObjectsResponse;
import software.amazon.awssdk.services.s3.model.ListObjectsV2Request;
import software.amazon.awssdk.services.s3.model.ListObjectsV2Response;
import software.amazon.awssdk.services.s3.model.ListPartsRequest;
import software.amazon.awssdk.services.s3.model.ListPartsResponse;
import software.amazon.awssdk.services.s3.model.PutBucketAccelerateConfigurationRequest;
import software.amazon.awssdk.services.s3.model.PutBucketAccelerateConfigurationResponse;
import software.amazon.awssdk.services.s3.model.PutBucketAclRequest;
import software.amazon.awssdk.services.s3.model.PutBucketAclResponse;
import software.amazon.awssdk.services.s3.model.PutBucketAnalyticsConfigurationRequest;
import software.amazon.awssdk.services.s3.model.PutBucketAnalyticsConfigurationResponse;
import software.amazon.awssdk.services.s3.model.PutBucketCorsRequest;
import software.amazon.awssdk.services.s3.model.PutBucketCorsResponse;
import software.amazon.awssdk.services.s3.model.PutBucketEncryptionRequest;
import software.amazon.awssdk.services.s3.model.PutBucketEncryptionResponse;
import software.amazon.awssdk.services.s3.model.PutBucketIntelligentTieringConfigurationRequest;
import software.amazon.awssdk.services.s3.model.PutBucketIntelligentTieringConfigurationResponse;
import software.amazon.awssdk.services.s3.model.PutBucketInventoryConfigurationRequest;
import software.amazon.awssdk.services.s3.model.PutBucketInventoryConfigurationResponse;
import software.amazon.awssdk.services.s3.model.PutBucketLifecycleConfigurationRequest;
import software.amazon.awssdk.services.s3.model.PutBucketLifecycleConfigurationResponse;
import software.amazon.awssdk.services.s3.model.PutBucketLoggingRequest;
import software.amazon.awssdk.services.s3.model.PutBucketLoggingResponse;
import software.amazon.awssdk.services.s3.model.PutBucketMetricsConfigurationRequest;
import software.amazon.awssdk.services.s3.model.PutBucketMetricsConfigurationResponse;
import software.amazon.awssdk.services.s3.model.PutBucketNotificationConfigurationRequest;
import software.amazon.awssdk.services.s3.model.PutBucketNotificationConfigurationResponse;
import software.amazon.awssdk.services.s3.model.PutBucketOwnershipControlsRequest;
import software.amazon.awssdk.services.s3.model.PutBucketOwnershipControlsResponse;
import software.amazon.awssdk.services.s3.model.PutBucketPolicyRequest;
import software.amazon.awssdk.services.s3.model.PutBucketPolicyResponse;
import software.amazon.awssdk.services.s3.model.PutBucketReplicationRequest;
import software.amazon.awssdk.services.s3.model.PutBucketReplicationResponse;
import software.amazon.awssdk.services.s3.model.PutBucketRequestPaymentRequest;
import software.amazon.awssdk.services.s3.model.PutBucketRequestPaymentResponse;
import software.amazon.awssdk.services.s3.model.PutBucketTaggingRequest;
import software.amazon.awssdk.services.s3.model.PutBucketTaggingResponse;
import software.amazon.awssdk.services.s3.model.PutBucketVersioningRequest;
import software.amazon.awssdk.services.s3.model.PutBucketVersioningResponse;
import software.amazon.awssdk.services.s3.model.PutBucketWebsiteRequest;
import software.amazon.awssdk.services.s3.model.PutBucketWebsiteResponse;
import software.amazon.awssdk.services.s3.model.PutObjectAclRequest;
import software.amazon.awssdk.services.s3.model.PutObjectAclResponse;
import software.amazon.awssdk.services.s3.model.PutObjectLegalHoldRequest;
import software.amazon.awssdk.services.s3.model.PutObjectLegalHoldResponse;
import software.amazon.awssdk.services.s3.model.PutObjectLockConfigurationRequest;
import software.amazon.awssdk.services.s3.model.PutObjectLockConfigurationResponse;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import software.amazon.awssdk.services.s3.model.PutObjectResponse;
import software.amazon.awssdk.services.s3.model.PutObjectRetentionRequest;
import software.amazon.awssdk.services.s3.model.PutObjectRetentionResponse;
import software.amazon.awssdk.services.s3.model.PutObjectTaggingRequest;
import software.amazon.awssdk.services.s3.model.PutObjectTaggingResponse;
import software.amazon.awssdk.services.s3.model.PutPublicAccessBlockRequest;
import software.amazon.awssdk.services.s3.model.PutPublicAccessBlockResponse;
import software.amazon.awssdk.services.s3.model.RestoreObjectRequest;
import software.amazon.awssdk.services.s3.model.RestoreObjectResponse;
import software.amazon.awssdk.services.s3.model.SelectObjectContentRequest;
import software.amazon.awssdk.services.s3.model.SelectObjectContentResponseHandler;
import software.amazon.awssdk.services.s3.model.UploadPartCopyRequest;
import software.amazon.awssdk.services.s3.model.UploadPartCopyResponse;
import software.amazon.awssdk.services.s3.model.UploadPartRequest;
import software.amazon.awssdk.services.s3.model.UploadPartResponse;
import software.amazon.awssdk.services.s3.model.WriteGetObjectResponseRequest;
import software.amazon.awssdk.services.s3.model.WriteGetObjectResponseResponse;
import software.amazon.awssdk.services.s3.paginators.ListMultipartUploadsPublisher;
import software.amazon.awssdk.services.s3.paginators.ListObjectVersionsPublisher;
import software.amazon.awssdk.services.s3.paginators.ListObjectsV2Publisher;
import software.amazon.awssdk.services.s3.paginators.ListPartsPublisher;
import software.amazon.awssdk.services.s3.waiters.S3AsyncWaiter;

public interface S3AsyncClient extends SdkClient
{
    default <ReturnT> java.util.concurrent.CompletableFuture<ReturnT> getObject(GetObjectRequest p0, software.amazon.awssdk.core.async.AsyncResponseTransformer<GetObjectResponse, ReturnT> p1){ return null; }
    default <ReturnT> java.util.concurrent.CompletableFuture<ReturnT> getObject(java.util.function.Consumer<GetObjectRequest.Builder> p0, software.amazon.awssdk.core.async.AsyncResponseTransformer<GetObjectResponse, ReturnT> p1){ return null; }
    default <ReturnT> java.util.concurrent.CompletableFuture<ReturnT> getObjectTorrent(GetObjectTorrentRequest p0, software.amazon.awssdk.core.async.AsyncResponseTransformer<GetObjectTorrentResponse, ReturnT> p1){ return null; }
    default <ReturnT> java.util.concurrent.CompletableFuture<ReturnT> getObjectTorrent(java.util.function.Consumer<GetObjectTorrentRequest.Builder> p0, software.amazon.awssdk.core.async.AsyncResponseTransformer<GetObjectTorrentResponse, ReturnT> p1){ return null; }
    default CompletableFuture<AbortMultipartUploadResponse> abortMultipartUpload(AbortMultipartUploadRequest p0){ return null; }
    default CompletableFuture<AbortMultipartUploadResponse> abortMultipartUpload(java.util.function.Consumer<AbortMultipartUploadRequest.Builder> p0){ return null; }
    default CompletableFuture<CompleteMultipartUploadResponse> completeMultipartUpload(CompleteMultipartUploadRequest p0){ return null; }
    default CompletableFuture<CompleteMultipartUploadResponse> completeMultipartUpload(java.util.function.Consumer<CompleteMultipartUploadRequest.Builder> p0){ return null; }
    default CompletableFuture<CopyObjectResponse> copyObject(CopyObjectRequest p0){ return null; }
    default CompletableFuture<CopyObjectResponse> copyObject(java.util.function.Consumer<CopyObjectRequest.Builder> p0){ return null; }
    default CompletableFuture<CreateBucketResponse> createBucket(CreateBucketRequest p0){ return null; }
    default CompletableFuture<CreateBucketResponse> createBucket(java.util.function.Consumer<CreateBucketRequest.Builder> p0){ return null; }
    default CompletableFuture<CreateMultipartUploadResponse> createMultipartUpload(CreateMultipartUploadRequest p0){ return null; }
    default CompletableFuture<CreateMultipartUploadResponse> createMultipartUpload(java.util.function.Consumer<CreateMultipartUploadRequest.Builder> p0){ return null; }
    default CompletableFuture<DeleteBucketAnalyticsConfigurationResponse> deleteBucketAnalyticsConfiguration(DeleteBucketAnalyticsConfigurationRequest p0){ return null; }
    default CompletableFuture<DeleteBucketAnalyticsConfigurationResponse> deleteBucketAnalyticsConfiguration(java.util.function.Consumer<DeleteBucketAnalyticsConfigurationRequest.Builder> p0){ return null; }
    default CompletableFuture<DeleteBucketCorsResponse> deleteBucketCors(DeleteBucketCorsRequest p0){ return null; }
    default CompletableFuture<DeleteBucketCorsResponse> deleteBucketCors(java.util.function.Consumer<DeleteBucketCorsRequest.Builder> p0){ return null; }
    default CompletableFuture<DeleteBucketEncryptionResponse> deleteBucketEncryption(DeleteBucketEncryptionRequest p0){ return null; }
    default CompletableFuture<DeleteBucketEncryptionResponse> deleteBucketEncryption(java.util.function.Consumer<DeleteBucketEncryptionRequest.Builder> p0){ return null; }
    default CompletableFuture<DeleteBucketIntelligentTieringConfigurationResponse> deleteBucketIntelligentTieringConfiguration(DeleteBucketIntelligentTieringConfigurationRequest p0){ return null; }
    default CompletableFuture<DeleteBucketIntelligentTieringConfigurationResponse> deleteBucketIntelligentTieringConfiguration(java.util.function.Consumer<DeleteBucketIntelligentTieringConfigurationRequest.Builder> p0){ return null; }
    default CompletableFuture<DeleteBucketInventoryConfigurationResponse> deleteBucketInventoryConfiguration(DeleteBucketInventoryConfigurationRequest p0){ return null; }
    default CompletableFuture<DeleteBucketInventoryConfigurationResponse> deleteBucketInventoryConfiguration(java.util.function.Consumer<DeleteBucketInventoryConfigurationRequest.Builder> p0){ return null; }
    default CompletableFuture<DeleteBucketLifecycleResponse> deleteBucketLifecycle(DeleteBucketLifecycleRequest p0){ return null; }
    default CompletableFuture<DeleteBucketLifecycleResponse> deleteBucketLifecycle(java.util.function.Consumer<DeleteBucketLifecycleRequest.Builder> p0){ return null; }
    default CompletableFuture<DeleteBucketMetricsConfigurationResponse> deleteBucketMetricsConfiguration(DeleteBucketMetricsConfigurationRequest p0){ return null; }
    default CompletableFuture<DeleteBucketMetricsConfigurationResponse> deleteBucketMetricsConfiguration(java.util.function.Consumer<DeleteBucketMetricsConfigurationRequest.Builder> p0){ return null; }
    default CompletableFuture<DeleteBucketOwnershipControlsResponse> deleteBucketOwnershipControls(DeleteBucketOwnershipControlsRequest p0){ return null; }
    default CompletableFuture<DeleteBucketOwnershipControlsResponse> deleteBucketOwnershipControls(java.util.function.Consumer<DeleteBucketOwnershipControlsRequest.Builder> p0){ return null; }
    default CompletableFuture<DeleteBucketPolicyResponse> deleteBucketPolicy(DeleteBucketPolicyRequest p0){ return null; }
    default CompletableFuture<DeleteBucketPolicyResponse> deleteBucketPolicy(java.util.function.Consumer<DeleteBucketPolicyRequest.Builder> p0){ return null; }
    default CompletableFuture<DeleteBucketReplicationResponse> deleteBucketReplication(DeleteBucketReplicationRequest p0){ return null; }
    default CompletableFuture<DeleteBucketReplicationResponse> deleteBucketReplication(java.util.function.Consumer<DeleteBucketReplicationRequest.Builder> p0){ return null; }
    default CompletableFuture<DeleteBucketResponse> deleteBucket(DeleteBucketRequest p0){ return null; }
    default CompletableFuture<DeleteBucketResponse> deleteBucket(java.util.function.Consumer<DeleteBucketRequest.Builder> p0){ return null; }
    default CompletableFuture<DeleteBucketTaggingResponse> deleteBucketTagging(DeleteBucketTaggingRequest p0){ return null; }
    default CompletableFuture<DeleteBucketTaggingResponse> deleteBucketTagging(java.util.function.Consumer<DeleteBucketTaggingRequest.Builder> p0){ return null; }
    default CompletableFuture<DeleteBucketWebsiteResponse> deleteBucketWebsite(DeleteBucketWebsiteRequest p0){ return null; }
    default CompletableFuture<DeleteBucketWebsiteResponse> deleteBucketWebsite(java.util.function.Consumer<DeleteBucketWebsiteRequest.Builder> p0){ return null; }
    default CompletableFuture<DeleteObjectResponse> deleteObject(DeleteObjectRequest p0){ return null; }
    default CompletableFuture<DeleteObjectResponse> deleteObject(java.util.function.Consumer<DeleteObjectRequest.Builder> p0){ return null; }
    default CompletableFuture<DeleteObjectTaggingResponse> deleteObjectTagging(DeleteObjectTaggingRequest p0){ return null; }
    default CompletableFuture<DeleteObjectTaggingResponse> deleteObjectTagging(java.util.function.Consumer<DeleteObjectTaggingRequest.Builder> p0){ return null; }
    default CompletableFuture<DeleteObjectsResponse> deleteObjects(DeleteObjectsRequest p0){ return null; }
    default CompletableFuture<DeleteObjectsResponse> deleteObjects(java.util.function.Consumer<DeleteObjectsRequest.Builder> p0){ return null; }
    default CompletableFuture<DeletePublicAccessBlockResponse> deletePublicAccessBlock(DeletePublicAccessBlockRequest p0){ return null; }
    default CompletableFuture<DeletePublicAccessBlockResponse> deletePublicAccessBlock(java.util.function.Consumer<DeletePublicAccessBlockRequest.Builder> p0){ return null; }
    default CompletableFuture<GetBucketAccelerateConfigurationResponse> getBucketAccelerateConfiguration(GetBucketAccelerateConfigurationRequest p0){ return null; }
    default CompletableFuture<GetBucketAccelerateConfigurationResponse> getBucketAccelerateConfiguration(java.util.function.Consumer<GetBucketAccelerateConfigurationRequest.Builder> p0){ return null; }
    default CompletableFuture<GetBucketAclResponse> getBucketAcl(GetBucketAclRequest p0){ return null; }
    default CompletableFuture<GetBucketAclResponse> getBucketAcl(java.util.function.Consumer<GetBucketAclRequest.Builder> p0){ return null; }
    default CompletableFuture<GetBucketAnalyticsConfigurationResponse> getBucketAnalyticsConfiguration(GetBucketAnalyticsConfigurationRequest p0){ return null; }
    default CompletableFuture<GetBucketAnalyticsConfigurationResponse> getBucketAnalyticsConfiguration(java.util.function.Consumer<GetBucketAnalyticsConfigurationRequest.Builder> p0){ return null; }
    default CompletableFuture<GetBucketCorsResponse> getBucketCors(GetBucketCorsRequest p0){ return null; }
    default CompletableFuture<GetBucketCorsResponse> getBucketCors(java.util.function.Consumer<GetBucketCorsRequest.Builder> p0){ return null; }
    default CompletableFuture<GetBucketEncryptionResponse> getBucketEncryption(GetBucketEncryptionRequest p0){ return null; }
    default CompletableFuture<GetBucketEncryptionResponse> getBucketEncryption(java.util.function.Consumer<GetBucketEncryptionRequest.Builder> p0){ return null; }
    default CompletableFuture<GetBucketIntelligentTieringConfigurationResponse> getBucketIntelligentTieringConfiguration(GetBucketIntelligentTieringConfigurationRequest p0){ return null; }
    default CompletableFuture<GetBucketIntelligentTieringConfigurationResponse> getBucketIntelligentTieringConfiguration(java.util.function.Consumer<GetBucketIntelligentTieringConfigurationRequest.Builder> p0){ return null; }
    default CompletableFuture<GetBucketInventoryConfigurationResponse> getBucketInventoryConfiguration(GetBucketInventoryConfigurationRequest p0){ return null; }
    default CompletableFuture<GetBucketInventoryConfigurationResponse> getBucketInventoryConfiguration(java.util.function.Consumer<GetBucketInventoryConfigurationRequest.Builder> p0){ return null; }
    default CompletableFuture<GetBucketLifecycleConfigurationResponse> getBucketLifecycleConfiguration(GetBucketLifecycleConfigurationRequest p0){ return null; }
    default CompletableFuture<GetBucketLifecycleConfigurationResponse> getBucketLifecycleConfiguration(java.util.function.Consumer<GetBucketLifecycleConfigurationRequest.Builder> p0){ return null; }
    default CompletableFuture<GetBucketLocationResponse> getBucketLocation(GetBucketLocationRequest p0){ return null; }
    default CompletableFuture<GetBucketLocationResponse> getBucketLocation(java.util.function.Consumer<GetBucketLocationRequest.Builder> p0){ return null; }
    default CompletableFuture<GetBucketLoggingResponse> getBucketLogging(GetBucketLoggingRequest p0){ return null; }
    default CompletableFuture<GetBucketLoggingResponse> getBucketLogging(java.util.function.Consumer<GetBucketLoggingRequest.Builder> p0){ return null; }
    default CompletableFuture<GetBucketMetricsConfigurationResponse> getBucketMetricsConfiguration(GetBucketMetricsConfigurationRequest p0){ return null; }
    default CompletableFuture<GetBucketMetricsConfigurationResponse> getBucketMetricsConfiguration(java.util.function.Consumer<GetBucketMetricsConfigurationRequest.Builder> p0){ return null; }
    default CompletableFuture<GetBucketNotificationConfigurationResponse> getBucketNotificationConfiguration(GetBucketNotificationConfigurationRequest p0){ return null; }
    default CompletableFuture<GetBucketNotificationConfigurationResponse> getBucketNotificationConfiguration(java.util.function.Consumer<GetBucketNotificationConfigurationRequest.Builder> p0){ return null; }
    default CompletableFuture<GetBucketOwnershipControlsResponse> getBucketOwnershipControls(GetBucketOwnershipControlsRequest p0){ return null; }
    default CompletableFuture<GetBucketOwnershipControlsResponse> getBucketOwnershipControls(java.util.function.Consumer<GetBucketOwnershipControlsRequest.Builder> p0){ return null; }
    default CompletableFuture<GetBucketPolicyResponse> getBucketPolicy(GetBucketPolicyRequest p0){ return null; }
    default CompletableFuture<GetBucketPolicyResponse> getBucketPolicy(java.util.function.Consumer<GetBucketPolicyRequest.Builder> p0){ return null; }
    default CompletableFuture<GetBucketPolicyStatusResponse> getBucketPolicyStatus(GetBucketPolicyStatusRequest p0){ return null; }
    default CompletableFuture<GetBucketPolicyStatusResponse> getBucketPolicyStatus(java.util.function.Consumer<GetBucketPolicyStatusRequest.Builder> p0){ return null; }
    default CompletableFuture<GetBucketReplicationResponse> getBucketReplication(GetBucketReplicationRequest p0){ return null; }
    default CompletableFuture<GetBucketReplicationResponse> getBucketReplication(java.util.function.Consumer<GetBucketReplicationRequest.Builder> p0){ return null; }
    default CompletableFuture<GetBucketRequestPaymentResponse> getBucketRequestPayment(GetBucketRequestPaymentRequest p0){ return null; }
    default CompletableFuture<GetBucketRequestPaymentResponse> getBucketRequestPayment(java.util.function.Consumer<GetBucketRequestPaymentRequest.Builder> p0){ return null; }
    default CompletableFuture<GetBucketTaggingResponse> getBucketTagging(GetBucketTaggingRequest p0){ return null; }
    default CompletableFuture<GetBucketTaggingResponse> getBucketTagging(java.util.function.Consumer<GetBucketTaggingRequest.Builder> p0){ return null; }
    default CompletableFuture<GetBucketVersioningResponse> getBucketVersioning(GetBucketVersioningRequest p0){ return null; }
    default CompletableFuture<GetBucketVersioningResponse> getBucketVersioning(java.util.function.Consumer<GetBucketVersioningRequest.Builder> p0){ return null; }
    default CompletableFuture<GetBucketWebsiteResponse> getBucketWebsite(GetBucketWebsiteRequest p0){ return null; }
    default CompletableFuture<GetBucketWebsiteResponse> getBucketWebsite(java.util.function.Consumer<GetBucketWebsiteRequest.Builder> p0){ return null; }
    default CompletableFuture<GetObjectAclResponse> getObjectAcl(GetObjectAclRequest p0){ return null; }
    default CompletableFuture<GetObjectAclResponse> getObjectAcl(java.util.function.Consumer<GetObjectAclRequest.Builder> p0){ return null; }
    default CompletableFuture<GetObjectAttributesResponse> getObjectAttributes(GetObjectAttributesRequest p0){ return null; }
    default CompletableFuture<GetObjectAttributesResponse> getObjectAttributes(java.util.function.Consumer<GetObjectAttributesRequest.Builder> p0){ return null; }
    default CompletableFuture<GetObjectLegalHoldResponse> getObjectLegalHold(GetObjectLegalHoldRequest p0){ return null; }
    default CompletableFuture<GetObjectLegalHoldResponse> getObjectLegalHold(java.util.function.Consumer<GetObjectLegalHoldRequest.Builder> p0){ return null; }
    default CompletableFuture<GetObjectLockConfigurationResponse> getObjectLockConfiguration(GetObjectLockConfigurationRequest p0){ return null; }
    default CompletableFuture<GetObjectLockConfigurationResponse> getObjectLockConfiguration(java.util.function.Consumer<GetObjectLockConfigurationRequest.Builder> p0){ return null; }
    default CompletableFuture<GetObjectResponse> getObject(GetObjectRequest p0, Path p1){ return null; }
    default CompletableFuture<GetObjectResponse> getObject(java.util.function.Consumer<GetObjectRequest.Builder> p0, Path p1){ return null; }
    default CompletableFuture<GetObjectRetentionResponse> getObjectRetention(GetObjectRetentionRequest p0){ return null; }
    default CompletableFuture<GetObjectRetentionResponse> getObjectRetention(java.util.function.Consumer<GetObjectRetentionRequest.Builder> p0){ return null; }
    default CompletableFuture<GetObjectTaggingResponse> getObjectTagging(GetObjectTaggingRequest p0){ return null; }
    default CompletableFuture<GetObjectTaggingResponse> getObjectTagging(java.util.function.Consumer<GetObjectTaggingRequest.Builder> p0){ return null; }
    default CompletableFuture<GetObjectTorrentResponse> getObjectTorrent(GetObjectTorrentRequest p0, Path p1){ return null; }
    default CompletableFuture<GetObjectTorrentResponse> getObjectTorrent(java.util.function.Consumer<GetObjectTorrentRequest.Builder> p0, Path p1){ return null; }
    default CompletableFuture<GetPublicAccessBlockResponse> getPublicAccessBlock(GetPublicAccessBlockRequest p0){ return null; }
    default CompletableFuture<GetPublicAccessBlockResponse> getPublicAccessBlock(java.util.function.Consumer<GetPublicAccessBlockRequest.Builder> p0){ return null; }
    default CompletableFuture<HeadBucketResponse> headBucket(HeadBucketRequest p0){ return null; }
    default CompletableFuture<HeadBucketResponse> headBucket(java.util.function.Consumer<HeadBucketRequest.Builder> p0){ return null; }
    default CompletableFuture<HeadObjectResponse> headObject(HeadObjectRequest p0){ return null; }
    default CompletableFuture<HeadObjectResponse> headObject(java.util.function.Consumer<HeadObjectRequest.Builder> p0){ return null; }
    default CompletableFuture<ListBucketAnalyticsConfigurationsResponse> listBucketAnalyticsConfigurations(ListBucketAnalyticsConfigurationsRequest p0){ return null; }
    default CompletableFuture<ListBucketAnalyticsConfigurationsResponse> listBucketAnalyticsConfigurations(java.util.function.Consumer<ListBucketAnalyticsConfigurationsRequest.Builder> p0){ return null; }
    default CompletableFuture<ListBucketIntelligentTieringConfigurationsResponse> listBucketIntelligentTieringConfigurations(ListBucketIntelligentTieringConfigurationsRequest p0){ return null; }
    default CompletableFuture<ListBucketIntelligentTieringConfigurationsResponse> listBucketIntelligentTieringConfigurations(java.util.function.Consumer<ListBucketIntelligentTieringConfigurationsRequest.Builder> p0){ return null; }
    default CompletableFuture<ListBucketInventoryConfigurationsResponse> listBucketInventoryConfigurations(ListBucketInventoryConfigurationsRequest p0){ return null; }
    default CompletableFuture<ListBucketInventoryConfigurationsResponse> listBucketInventoryConfigurations(java.util.function.Consumer<ListBucketInventoryConfigurationsRequest.Builder> p0){ return null; }
    default CompletableFuture<ListBucketMetricsConfigurationsResponse> listBucketMetricsConfigurations(ListBucketMetricsConfigurationsRequest p0){ return null; }
    default CompletableFuture<ListBucketMetricsConfigurationsResponse> listBucketMetricsConfigurations(java.util.function.Consumer<ListBucketMetricsConfigurationsRequest.Builder> p0){ return null; }
    default CompletableFuture<ListBucketsResponse> listBuckets(){ return null; }
    default CompletableFuture<ListBucketsResponse> listBuckets(ListBucketsRequest p0){ return null; }
    default CompletableFuture<ListBucketsResponse> listBuckets(java.util.function.Consumer<ListBucketsRequest.Builder> p0){ return null; }
    default CompletableFuture<ListMultipartUploadsResponse> listMultipartUploads(ListMultipartUploadsRequest p0){ return null; }
    default CompletableFuture<ListMultipartUploadsResponse> listMultipartUploads(java.util.function.Consumer<ListMultipartUploadsRequest.Builder> p0){ return null; }
    default CompletableFuture<ListObjectVersionsResponse> listObjectVersions(ListObjectVersionsRequest p0){ return null; }
    default CompletableFuture<ListObjectVersionsResponse> listObjectVersions(java.util.function.Consumer<ListObjectVersionsRequest.Builder> p0){ return null; }
    default CompletableFuture<ListObjectsResponse> listObjects(ListObjectsRequest p0){ return null; }
    default CompletableFuture<ListObjectsResponse> listObjects(java.util.function.Consumer<ListObjectsRequest.Builder> p0){ return null; }
    default CompletableFuture<ListObjectsV2Response> listObjectsV2(ListObjectsV2Request p0){ return null; }
    default CompletableFuture<ListObjectsV2Response> listObjectsV2(java.util.function.Consumer<ListObjectsV2Request.Builder> p0){ return null; }
    default CompletableFuture<ListPartsResponse> listParts(ListPartsRequest p0){ return null; }
    default CompletableFuture<ListPartsResponse> listParts(java.util.function.Consumer<ListPartsRequest.Builder> p0){ return null; }
    default CompletableFuture<PutBucketAccelerateConfigurationResponse> putBucketAccelerateConfiguration(PutBucketAccelerateConfigurationRequest p0){ return null; }
    default CompletableFuture<PutBucketAccelerateConfigurationResponse> putBucketAccelerateConfiguration(java.util.function.Consumer<PutBucketAccelerateConfigurationRequest.Builder> p0){ return null; }
    default CompletableFuture<PutBucketAclResponse> putBucketAcl(PutBucketAclRequest p0){ return null; }
    default CompletableFuture<PutBucketAclResponse> putBucketAcl(java.util.function.Consumer<PutBucketAclRequest.Builder> p0){ return null; }
    default CompletableFuture<PutBucketAnalyticsConfigurationResponse> putBucketAnalyticsConfiguration(PutBucketAnalyticsConfigurationRequest p0){ return null; }
    default CompletableFuture<PutBucketAnalyticsConfigurationResponse> putBucketAnalyticsConfiguration(java.util.function.Consumer<PutBucketAnalyticsConfigurationRequest.Builder> p0){ return null; }
    default CompletableFuture<PutBucketCorsResponse> putBucketCors(PutBucketCorsRequest p0){ return null; }
    default CompletableFuture<PutBucketCorsResponse> putBucketCors(java.util.function.Consumer<PutBucketCorsRequest.Builder> p0){ return null; }
    default CompletableFuture<PutBucketEncryptionResponse> putBucketEncryption(PutBucketEncryptionRequest p0){ return null; }
    default CompletableFuture<PutBucketEncryptionResponse> putBucketEncryption(java.util.function.Consumer<PutBucketEncryptionRequest.Builder> p0){ return null; }
    default CompletableFuture<PutBucketIntelligentTieringConfigurationResponse> putBucketIntelligentTieringConfiguration(PutBucketIntelligentTieringConfigurationRequest p0){ return null; }
    default CompletableFuture<PutBucketIntelligentTieringConfigurationResponse> putBucketIntelligentTieringConfiguration(java.util.function.Consumer<PutBucketIntelligentTieringConfigurationRequest.Builder> p0){ return null; }
    default CompletableFuture<PutBucketInventoryConfigurationResponse> putBucketInventoryConfiguration(PutBucketInventoryConfigurationRequest p0){ return null; }
    default CompletableFuture<PutBucketInventoryConfigurationResponse> putBucketInventoryConfiguration(java.util.function.Consumer<PutBucketInventoryConfigurationRequest.Builder> p0){ return null; }
    default CompletableFuture<PutBucketLifecycleConfigurationResponse> putBucketLifecycleConfiguration(PutBucketLifecycleConfigurationRequest p0){ return null; }
    default CompletableFuture<PutBucketLifecycleConfigurationResponse> putBucketLifecycleConfiguration(java.util.function.Consumer<PutBucketLifecycleConfigurationRequest.Builder> p0){ return null; }
    default CompletableFuture<PutBucketLoggingResponse> putBucketLogging(PutBucketLoggingRequest p0){ return null; }
    default CompletableFuture<PutBucketLoggingResponse> putBucketLogging(java.util.function.Consumer<PutBucketLoggingRequest.Builder> p0){ return null; }
    default CompletableFuture<PutBucketMetricsConfigurationResponse> putBucketMetricsConfiguration(PutBucketMetricsConfigurationRequest p0){ return null; }
    default CompletableFuture<PutBucketMetricsConfigurationResponse> putBucketMetricsConfiguration(java.util.function.Consumer<PutBucketMetricsConfigurationRequest.Builder> p0){ return null; }
    default CompletableFuture<PutBucketNotificationConfigurationResponse> putBucketNotificationConfiguration(PutBucketNotificationConfigurationRequest p0){ return null; }
    default CompletableFuture<PutBucketNotificationConfigurationResponse> putBucketNotificationConfiguration(java.util.function.Consumer<PutBucketNotificationConfigurationRequest.Builder> p0){ return null; }
    default CompletableFuture<PutBucketOwnershipControlsResponse> putBucketOwnershipControls(PutBucketOwnershipControlsRequest p0){ return null; }
    default CompletableFuture<PutBucketOwnershipControlsResponse> putBucketOwnershipControls(java.util.function.Consumer<PutBucketOwnershipControlsRequest.Builder> p0){ return null; }
    default CompletableFuture<PutBucketPolicyResponse> putBucketPolicy(PutBucketPolicyRequest p0){ return null; }
    default CompletableFuture<PutBucketPolicyResponse> putBucketPolicy(java.util.function.Consumer<PutBucketPolicyRequest.Builder> p0){ return null; }
    default CompletableFuture<PutBucketReplicationResponse> putBucketReplication(PutBucketReplicationRequest p0){ return null; }
    default CompletableFuture<PutBucketReplicationResponse> putBucketReplication(java.util.function.Consumer<PutBucketReplicationRequest.Builder> p0){ return null; }
    default CompletableFuture<PutBucketRequestPaymentResponse> putBucketRequestPayment(PutBucketRequestPaymentRequest p0){ return null; }
    default CompletableFuture<PutBucketRequestPaymentResponse> putBucketRequestPayment(java.util.function.Consumer<PutBucketRequestPaymentRequest.Builder> p0){ return null; }
    default CompletableFuture<PutBucketTaggingResponse> putBucketTagging(PutBucketTaggingRequest p0){ return null; }
    default CompletableFuture<PutBucketTaggingResponse> putBucketTagging(java.util.function.Consumer<PutBucketTaggingRequest.Builder> p0){ return null; }
    default CompletableFuture<PutBucketVersioningResponse> putBucketVersioning(PutBucketVersioningRequest p0){ return null; }
    default CompletableFuture<PutBucketVersioningResponse> putBucketVersioning(java.util.function.Consumer<PutBucketVersioningRequest.Builder> p0){ return null; }
    default CompletableFuture<PutBucketWebsiteResponse> putBucketWebsite(PutBucketWebsiteRequest p0){ return null; }
    default CompletableFuture<PutBucketWebsiteResponse> putBucketWebsite(java.util.function.Consumer<PutBucketWebsiteRequest.Builder> p0){ return null; }
    default CompletableFuture<PutObjectAclResponse> putObjectAcl(PutObjectAclRequest p0){ return null; }
    default CompletableFuture<PutObjectAclResponse> putObjectAcl(java.util.function.Consumer<PutObjectAclRequest.Builder> p0){ return null; }
    default CompletableFuture<PutObjectLegalHoldResponse> putObjectLegalHold(PutObjectLegalHoldRequest p0){ return null; }
    default CompletableFuture<PutObjectLegalHoldResponse> putObjectLegalHold(java.util.function.Consumer<PutObjectLegalHoldRequest.Builder> p0){ return null; }
    default CompletableFuture<PutObjectLockConfigurationResponse> putObjectLockConfiguration(PutObjectLockConfigurationRequest p0){ return null; }
    default CompletableFuture<PutObjectLockConfigurationResponse> putObjectLockConfiguration(java.util.function.Consumer<PutObjectLockConfigurationRequest.Builder> p0){ return null; }
    default CompletableFuture<PutObjectResponse> putObject(PutObjectRequest p0, AsyncRequestBody p1){ return null; }
    default CompletableFuture<PutObjectResponse> putObject(PutObjectRequest p0, Path p1){ return null; }
    default CompletableFuture<PutObjectResponse> putObject(java.util.function.Consumer<PutObjectRequest.Builder> p0, AsyncRequestBody p1){ return null; }
    default CompletableFuture<PutObjectResponse> putObject(java.util.function.Consumer<PutObjectRequest.Builder> p0, Path p1){ return null; }
    default CompletableFuture<PutObjectRetentionResponse> putObjectRetention(PutObjectRetentionRequest p0){ return null; }
    default CompletableFuture<PutObjectRetentionResponse> putObjectRetention(java.util.function.Consumer<PutObjectRetentionRequest.Builder> p0){ return null; }
    default CompletableFuture<PutObjectTaggingResponse> putObjectTagging(PutObjectTaggingRequest p0){ return null; }
    default CompletableFuture<PutObjectTaggingResponse> putObjectTagging(java.util.function.Consumer<PutObjectTaggingRequest.Builder> p0){ return null; }
    default CompletableFuture<PutPublicAccessBlockResponse> putPublicAccessBlock(PutPublicAccessBlockRequest p0){ return null; }
    default CompletableFuture<PutPublicAccessBlockResponse> putPublicAccessBlock(java.util.function.Consumer<PutPublicAccessBlockRequest.Builder> p0){ return null; }
    default CompletableFuture<RestoreObjectResponse> restoreObject(RestoreObjectRequest p0){ return null; }
    default CompletableFuture<RestoreObjectResponse> restoreObject(java.util.function.Consumer<RestoreObjectRequest.Builder> p0){ return null; }
    default CompletableFuture<UploadPartCopyResponse> uploadPartCopy(UploadPartCopyRequest p0){ return null; }
    default CompletableFuture<UploadPartCopyResponse> uploadPartCopy(java.util.function.Consumer<UploadPartCopyRequest.Builder> p0){ return null; }
    default CompletableFuture<UploadPartResponse> uploadPart(UploadPartRequest p0, AsyncRequestBody p1){ return null; }
    default CompletableFuture<UploadPartResponse> uploadPart(UploadPartRequest p0, Path p1){ return null; }
    default CompletableFuture<UploadPartResponse> uploadPart(java.util.function.Consumer<UploadPartRequest.Builder> p0, AsyncRequestBody p1){ return null; }
    default CompletableFuture<UploadPartResponse> uploadPart(java.util.function.Consumer<UploadPartRequest.Builder> p0, Path p1){ return null; }
    default CompletableFuture<Void> selectObjectContent(SelectObjectContentRequest p0, SelectObjectContentResponseHandler p1){ return null; }
    default CompletableFuture<Void> selectObjectContent(java.util.function.Consumer<SelectObjectContentRequest.Builder> p0, SelectObjectContentResponseHandler p1){ return null; }
    default CompletableFuture<WriteGetObjectResponseResponse> writeGetObjectResponse(WriteGetObjectResponseRequest p0, AsyncRequestBody p1){ return null; }
    default CompletableFuture<WriteGetObjectResponseResponse> writeGetObjectResponse(WriteGetObjectResponseRequest p0, Path p1){ return null; }
    default CompletableFuture<WriteGetObjectResponseResponse> writeGetObjectResponse(java.util.function.Consumer<WriteGetObjectResponseRequest.Builder> p0, AsyncRequestBody p1){ return null; }
    default CompletableFuture<WriteGetObjectResponseResponse> writeGetObjectResponse(java.util.function.Consumer<WriteGetObjectResponseRequest.Builder> p0, Path p1){ return null; }
    default ListMultipartUploadsPublisher listMultipartUploadsPaginator(ListMultipartUploadsRequest p0){ return null; }
    default ListMultipartUploadsPublisher listMultipartUploadsPaginator(java.util.function.Consumer<ListMultipartUploadsRequest.Builder> p0){ return null; }
    default ListObjectVersionsPublisher listObjectVersionsPaginator(ListObjectVersionsRequest p0){ return null; }
    default ListObjectVersionsPublisher listObjectVersionsPaginator(java.util.function.Consumer<ListObjectVersionsRequest.Builder> p0){ return null; }
    default ListObjectsV2Publisher listObjectsV2Paginator(ListObjectsV2Request p0){ return null; }
    default ListObjectsV2Publisher listObjectsV2Paginator(java.util.function.Consumer<ListObjectsV2Request.Builder> p0){ return null; }
    default ListPartsPublisher listPartsPaginator(ListPartsRequest p0){ return null; }
    default ListPartsPublisher listPartsPaginator(java.util.function.Consumer<ListPartsRequest.Builder> p0){ return null; }
    default S3AsyncWaiter waiter(){ return null; }
    default S3Utilities utilities(){ return null; }
    static S3AsyncClient create(){ return null; }
    static S3AsyncClient crtCreate(){ return null; }
    static S3AsyncClientBuilder builder(){ return null; }
    static S3CrtAsyncClientBuilder crtBuilder(){ return null; }
    static String SERVICE_METADATA_ID = null;
    static String SERVICE_NAME = null;
}
