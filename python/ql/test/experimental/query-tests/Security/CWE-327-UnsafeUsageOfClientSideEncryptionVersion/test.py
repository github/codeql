from azure.storage.blob import BlobServiceClient, ContainerClient, BlobClient

BSC = BlobServiceClient.from_connection_string(...)

def unsafe():
    # does not set encryption_version to 2.0, default is unsafe
    blob_client = BSC.get_blob_client(...)
    blob_client.require_encryption = True
    blob_client.key_encryption_key = ...
    with open("decryptedcontentfile.txt", "rb") as stream:
        blob_client.upload_blob(stream) # BAD


def unsafe_setting_on_blob_service_client():
    blob_service_client = BlobServiceClient.from_connection_string(...)
    blob_service_client.require_encryption = True
    blob_service_client.key_encryption_key = ...

    blob_client = blob_service_client.get_blob_client(...)
    with open("decryptedcontentfile.txt", "rb") as stream:
        blob_client.upload_blob(stream)


def unsafe_setting_on_container_client():
    container_client = ContainerClient.from_connection_string(...)
    container_client.require_encryption = True
    container_client.key_encryption_key = ...

    blob_client = container_client.get_blob_client(...)
    with open("decryptedcontentfile.txt", "rb") as stream:
        blob_client.upload_blob(stream)


def potentially_unsafe(use_new_version=False):
    blob_client = BSC.get_blob_client(...)
    blob_client.require_encryption = True
    blob_client.key_encryption_key = ...

    if use_new_version:
        blob_client.encryption_version = '2.0'

    with open("decryptedcontentfile.txt", "rb") as stream:
        blob_client.upload_blob(stream) # BAD


def safe():
    blob_client = BSC.get_blob_client(...)
    blob_client.require_encryption = True
    blob_client.key_encryption_key = ...
    # GOOD: Must use `encryption_version` set to `2.0`
    blob_client.encryption_version = '2.0'
    with open("decryptedcontentfile.txt", "rb") as stream:
        blob_client.upload_blob(stream) # OK


def safe_different_order():
    blob_client: BlobClient = BSC.get_blob_client(...)
    blob_client.encryption_version = '2.0'
    blob_client.require_encryption = True
    blob_client.key_encryption_key = ...
    with open("decryptedcontentfile.txt", "rb") as stream:
        blob_client.upload_blob(stream) # OK


def get_unsafe_blob_client():
    blob_client = BSC.get_blob_client(...)
    blob_client.require_encryption = True
    blob_client.key_encryption_key = ...
    return blob_client


def unsafe_with_calls():
    bc = get_unsafe_blob_client()
    with open("decryptedcontentfile.txt", "rb") as stream:
        bc.upload_blob(stream) # BAD


def get_safe_blob_client():
    blob_client = BSC.get_blob_client(...)
    blob_client.require_encryption = True
    blob_client.key_encryption_key = ...
    blob_client.encryption_version = '2.0'
    return blob_client


def safe_with_calls():
    bc = get_safe_blob_client()
    with open("decryptedcontentfile.txt", "rb") as stream:
        bc.upload_blob(stream) # OK
