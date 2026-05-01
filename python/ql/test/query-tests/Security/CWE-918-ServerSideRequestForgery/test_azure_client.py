from azure.keyvault.secrets import SecretClient
from azure.storage.fileshare import ShareFileClient
from azure.keyvault.keys import KeyClient
from azure.storage.blob import ContainerClient
from azure.storage.blob import download_blob_from_url
from flask import request # $ Source

def azure_sdk_test(credential, output_path):
    user_input = request.args['untrusted_input']
    user_input2 = request.args['untrusted_input2']

    url = f"https://example.com/foo#{user_input}"
    full_url = f"https://{user_input2}"
    # Testing Azure sink
    SecretClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]
    SecretClient(vault_url=full_url, credential=credential) # $ Alert[py/full-ssrf]
    ShareFileClient.from_file_url(url) # $ Alert[py/partial-ssrf]
    ShareFileClient.from_file_url(full_url) # $ Alert[py/full-ssrf]
    KeyClient(url, credential) # $ Alert[py/partial-ssrf]
    KeyClient(full_url, credential) # $ Alert[py/full-ssrf]
    ContainerClient.from_container_url(container_url=url, credential=credential) # $ Alert[py/partial-ssrf]
    ContainerClient.from_container_url(container_url=full_url, credential=credential) # $ Alert[py/full-ssrf]

    download_blob_from_url(blob_url=url, output=output_path, credential=credential, overwrite=True ) # $ Alert[py/partial-ssrf]
    download_blob_from_url(blob_url=full_url, output=output_path, credential=credential, overwrite=True) # $ Alert[py/full-ssrf]
