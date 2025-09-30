from azure.keyvault.secrets import SecretClient
from azure.storage.fileshare import ShareFileClient
from azure.keyvault.keys import KeyClient
from azure.storage.blob import ContainerClient
from azure.storage.blob import download_blob_from_url

from flask import request

def azure_sdk_test(credential, output_path):
    user_input = request.args['untrusted_input']
    user_input2 = request.args['untrusted_input2']

    url = f"https://example.com/foo#{user_input}"
    full_url = f"https://{user_input2}"
    # Testing Azure sink
    c = SecretClient(vault_url=url, credential=credential)# NOT OK -- user only controlled fragment
    c = SecretClient(vault_url=full_url, credential=credential) # NOT OK -- user has full control
    c = ShareFileClient.from_file_url(url) # NOT OK -- user only controlled fragment
    c = ShareFileClient.from_file_url(full_url) # NOT OK -- user has full control
    c = KeyClient(url, credential)# NOT OK -- user only controlled fragment
    c = KeyClient(full_url, credential) # NOT OK -- user has full control
    c = ContainerClient.from_container_url(container_url=url, credential=credential) # NOT OK -- user only controlled fragment
    c = ContainerClient.from_container_url(container_url=full_url, credential=credential) # NOT OK -- user has full control

    download_blob_from_url(
        blob_url=url, # NOT OK -- user only controlled fragment
        output=output_path,
        credential=credential,
        overwrite=True 
    )
    download_blob_from_url(
        blob_url=full_url, # NOT OK -- user has full control
        output=output_path,
        credential=credential,
        overwrite=True 
    )
