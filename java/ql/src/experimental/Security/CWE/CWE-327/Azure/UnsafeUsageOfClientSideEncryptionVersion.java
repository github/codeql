
// BAD: Using an outdated SDK that does not support client side encryption version V2_0
new EncryptedBlobClientBuilder()
        .blobClient(blobClient)
        .key(resolver.buildAsyncKeyEncryptionKey(keyid).block(), keyWrapAlgorithm)
        .buildEncryptedBlobClient()
        .uploadWithResponse(new BlobParallelUploadOptions(data)
                        .setMetadata(metadata)
                        .setHeaders(headers)
                        .setTags(tags)
                        .setTier(tier)
                        .setRequestConditions(requestConditions)
                        .setComputeMd5(computeMd5)
                        .setParallelTransferOptions(parallelTransferOptions),
                timeout, context);

// BAD: Using the deprecatedd client side encryption version V1_0
new EncryptedBlobClientBuilder(EncryptionVersion.V1)
        .blobClient(blobClient)
        .key(resolver.buildAsyncKeyEncryptionKey(keyid).block(), keyWrapAlgorithm)
        .buildEncryptedBlobClient()
        .uploadWithResponse(new BlobParallelUploadOptions(data)
                        .setMetadata(metadata)
                        .setHeaders(headers)
                        .setTags(tags)
                        .setTier(tier)
                        .setRequestConditions(requestConditions)
                        .setComputeMd5(computeMd5)
                        .setParallelTransferOptions(parallelTransferOptions),
                timeout, context);


// GOOD: Using client side encryption version V2_0
new EncryptedBlobClientBuilder(EncryptionVersion.V2)
        .blobClient(blobClient)
        .key(resolver.buildAsyncKeyEncryptionKey(keyid).block(), keyWrapAlgorithm)
        .buildEncryptedBlobClient()
        .uploadWithResponse(new BlobParallelUploadOptions(data)
                        .setMetadata(metadata)
                        .setHeaders(headers)
                        .setTags(tags)
                        .setTier(tier)
                        .setRequestConditions(requestConditions)
                        .setComputeMd5(computeMd5)
                        .setParallelTransferOptions(parallelTransferOptions),
                timeout, context);
