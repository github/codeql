blob_client = blob_service_client.get_blob_client(container=container_name, blob=blob_name)
blob_client.require_encryption = True
blob_client.key_encryption_key = kek
# GOOD: Must use `encryption_version` set to `2.0`
blob_client.encryption_version = '2.0'  # Use Version 2.0!
with open("decryptedcontentfile.txt", "rb") as stream:
    blob_client.upload_blob(stream, overwrite=OVERWRITE_EXISTING)