from azure.storage.blob import BlobServiceClient


def unsafe():
    # does not set encryption_version to 2.0, default is unsafe
    blob_client = BlobServiceClient.get_blob_client(...)
    blob_client.require_encryption = True
    blob_client.key_encryption_key = ...
    with open("decryptedcontentfile.txt", "rb") as stream:
        blob_client.upload_blob(stream) # BAD


def potentially_unsafe(use_new_version=False):
    blob_client = BlobServiceClient.get_blob_client(...)
    blob_client.require_encryption = True
    blob_client.key_encryption_key = ...

    if use_new_version:
        blob_client.encryption_version = '2.0'

    with open("decryptedcontentfile.txt", "rb") as stream:
        blob_client.upload_blob(stream) # BAD


def safe():
    blob_client = BlobServiceClient.get_blob_client(...)
    blob_client.require_encryption = True
    blob_client.key_encryption_key = ...
    # GOOD: Must use `encryption_version` set to `2.0`
    blob_client.encryption_version = '2.0'
    with open("decryptedcontentfile.txt", "rb") as stream:
        blob_client.upload_blob(stream) # OK


def get_unsafe_blob_client():
    blob_client = BlobServiceClient.get_blob_client(...)
    blob_client.require_encryption = True
    blob_client.key_encryption_key = ...
    return blob_client


def unsafe_with_calls():
    bc = get_unsafe_blob_client()
    with open("decryptedcontentfile.txt", "rb") as stream:
        bc.upload_blob(stream) # BAD


def get_safe_blob_client():
    blob_client = BlobServiceClient.get_blob_client(...)
    blob_client.require_encryption = True
    blob_client.key_encryption_key = ...
    blob_client.encryption_version = '2.0'
    return blob_client


def safe_with_calls():
    bc = get_safe_blob_client()
    with open("decryptedcontentfile.txt", "rb") as stream:
        bc.upload_blob(stream) # OK
