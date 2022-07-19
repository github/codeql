
{
    SymmetricKey aesKey = new SymmetricKey(kid: "symencryptionkey");

    // BAD: Using the outdated client side encryption version V1_0
    BlobEncryptionPolicy uploadPolicy = new BlobEncryptionPolicy(key: aesKey, keyResolver: null);
    BlobRequestOptions uploadOptions = new BlobRequestOptions() { EncryptionPolicy = uploadPolicy };

    MemoryStream stream = new MemoryStream(buffer);
    blob.UploadFromStream(stream, length: size, accessCondition: null, options: uploadOptions);
}

var client = new BlobClient(myConnectionString, new SpecializedBlobClientOptions()
{
    // BAD: Using an outdated SDK that does not support client side encryption version V2_0
    ClientSideEncryption = new ClientSideEncryptionOptions() 
    {
        KeyEncryptionKey = myKey,
        KeyResolver = myKeyResolver,
        KeyWrapAlgorihm = myKeyWrapAlgorithm
    }
});

var client = new BlobClient(myConnectionString, new SpecializedBlobClientOptions()
{
    // BAD: Using the outdated client side encryption version V1_0
    ClientSideEncryption = new ClientSideEncryptionOptions(ClientSideEncryptionVersion.V1_0) 
    {
        KeyEncryptionKey = myKey,
        KeyResolver = myKeyResolver,
        KeyWrapAlgorihm = myKeyWrapAlgorithm
    }
});

var client = new BlobClient(myConnectionString, new SpecializedBlobClientOptions()
{
    // GOOD: Using client side encryption version V2_0
    ClientSideEncryption = new ClientSideEncryptionOptions(ClientSideEncryptionVersion.V2_0) 
    {
        KeyEncryptionKey = myKey,
        KeyResolver = myKeyResolver,
        KeyWrapAlgorihm = myKeyWrapAlgorithm
    }
});