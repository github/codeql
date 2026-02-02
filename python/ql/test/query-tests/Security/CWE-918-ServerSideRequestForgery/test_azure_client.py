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
    c = SecretClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]
    c = SecretClient(vault_url=full_url, credential=credential) # $ Alert[py/full-ssrf]
    c = ShareFileClient.from_file_url(url) # $ Alert[py/partial-ssrf]
    c = ShareFileClient.from_file_url(full_url) # $ Alert[py/full-ssrf]
    c = KeyClient(url, credential) # $ Alert[py/partial-ssrf]
    c = KeyClient(full_url, credential) # $ Alert[py/full-ssrf]
    c = ContainerClient.from_container_url(container_url=url, credential=credential) # $ Alert[py/partial-ssrf]
    c = ContainerClient.from_container_url(container_url=full_url, credential=credential) # $ Alert[py/full-ssrf]

    download_blob_from_url(blob_url=url, output=output_path, credential=credential, overwrite=True ) # $ Alert[py/partial-ssrf]
    download_blob_from_url(blob_url=full_url, output=output_path, credential=credential, overwrite=True) # $ Alert[py/full-ssrf]

#     if URIValidator.in_domain(url, trusted_domain):
#         # Testing Azure sink
#         c = SecretClient(vault_url=url, credential=credential)# OK 
#         c = ShareFileClient.from_file_url(url) #  OK 
#         c = KeyClient(url, credential)# OK 
#         c = ContainerClient.from_container_url(container_url=url, credential=credential) # OK 

#         download_blob_from_url(
#             blob_url=url, # OK 
#             output=output_path,
#             credential=credential,
#             overwrite=True 
#         )
#     else:
#         # Testing Azure sink
#         c = SecretClient(vault_url=url, credential=credential)# NOT OK -- user only controlled fragment
#         c = ShareFileClient.from_file_url(url) # NOT OK -- user only controlled fragment
#         c = KeyClient(url, credential)# NOT OK -- user only controlled fragment
#         c = ContainerClient.from_container_url(container_url=url, credential=credential) # NOT OK -- user only controlled fragment

#         download_blob_from_url(
#             blob_url=url, # NOT OK -- user only controlled fragment
#             output=output_path,
#             credential=credential,
#             overwrite=True 
#         )


#     if URIValidator.in_domain(full_url, trusted_domain):
#         # Testing Azure sink
#         c = SecretClient(vault_url=full_url, credential=credential) # OK
#         c = ShareFileClient.from_file_url(full_url) # OK
#         c = KeyClient(full_url, credential) # OK
#         c = ContainerClient.from_container_url(container_url=full_url, credential=credential) # OK

#         download_blob_from_url(
#             blob_url=full_url, # OK
#             output=output_path,
#             credential=credential,
#             overwrite=True 
#         )
#     else:
#         # Testing Azure sink
#         c = SecretClient(vault_url=full_url, credential=credential) # NOT OK -- user has full control
#         c = ShareFileClient.from_file_url(full_url) # NOT OK -- user has full control
#         c = KeyClient(full_url, credential) # NOT OK -- user has full control
#         c = ContainerClient.from_container_url(container_url=full_url, credential=credential) # NOT OK -- user has full control

#         download_blob_from_url(
#             blob_url=full_url, # NOT OK -- user has full control
#             output=output_path,
#             credential=credential,
#             overwrite=True 
#         )


#     if URIValidator.in_azure_keyvault_domain(url):
#         # Testing Azure sink
#         c = SecretClient(vault_url=url, credential=credential)# OK 
#         c = ShareFileClient.from_file_url(url) #  OK 
#         c = KeyClient(url, credential)# OK 
#         c = ContainerClient.from_container_url(container_url=url, credential=credential) # OK 

#         download_blob_from_url(
#             blob_url=url, # OK 
#             output=output_path,
#             credential=credential,
#             overwrite=True 
#         )
#     else:
#         # Testing Azure sink
#         c = SecretClient(vault_url=url, credential=credential)# NOT OK -- user only controlled fragment
#         c = ShareFileClient.from_file_url(url) # NOT OK -- user only controlled fragment
#         c = KeyClient(url, credential)# NOT OK -- user only controlled fragment
#         c = ContainerClient.from_container_url(container_url=url, credential=credential) # NOT OK -- user only controlled fragment

#         download_blob_from_url(
#             blob_url=url, # NOT OK -- user only controlled fragment
#             output=output_path,
#             credential=credential,
#             overwrite=True 
#         )


#     if URIValidator.in_azure_keyvault_domain(full_url):
#         # Testing Azure sink
#         c = SecretClient(vault_url=full_url, credential=credential) # OK
#         c = ShareFileClient.from_file_url(full_url) # OK
#         c = KeyClient(full_url, credential) # OK
#         c = ContainerClient.from_container_url(container_url=full_url, credential=credential) # OK

#         download_blob_from_url(
#             blob_url=full_url, # OK
#             output=output_path,
#             credential=credential,
#             overwrite=True 
#         )
#     else:
#         # Testing Azure sink
#         c = SecretClient(vault_url=full_url, credential=credential) # NOT OK -- user has full control
#         c = ShareFileClient.from_file_url(full_url) # NOT OK -- user has full control
#         c = KeyClient(full_url, credential) # NOT OK -- user has full control
#         c = ContainerClient.from_container_url(container_url=full_url, credential=credential) # NOT OK -- user has full control

#         download_blob_from_url(
#             blob_url=full_url, # NOT OK -- user has full control
#             output=output_path,
#             credential=credential,
#             overwrite=True 
#         )  

#     if URIValidator.in_azure_storage_domain(url):
#         # Testing Azure sink
#         c = SecretClient(vault_url=url, credential=credential)# OK 
#         c = ShareFileClient.from_file_url(url) #  OK 
#         c = KeyClient(url, credential)# OK 
#         c = ContainerClient.from_container_url(container_url=url, credential=credential) # OK 

#         download_blob_from_url(
#             blob_url=url, # OK 
#             output=output_path,
#             credential=credential,
#             overwrite=True 
#         )
#     else:
#         # Testing Azure sink
#         c = SecretClient(vault_url=url, credential=credential)# NOT OK -- user only controlled fragment
#         c = ShareFileClient.from_file_url(url) # NOT OK -- user only controlled fragment
#         c = KeyClient(url, credential)# NOT OK -- user only controlled fragment
#         c = ContainerClient.from_container_url(container_url=url, credential=credential) # NOT OK -- user only controlled fragment

#         download_blob_from_url(
#             blob_url=url, # NOT OK -- user only controlled fragment
#             output=output_path,
#             credential=credential,
#             overwrite=True 
#         )


#     if URIValidator.in_azure_storage_domain(full_url):
#         # Testing Azure sink
#         c = SecretClient(vault_url=full_url, credential=credential) # OK
#         c = ShareFileClient.from_file_url(full_url) # OK
#         c = KeyClient(full_url, credential) # OK
#         c = ContainerClient.from_container_url(container_url=full_url, credential=credential) # OK

#         download_blob_from_url(
#             blob_url=full_url, # OK
#             output=output_path,
#             credential=credential,
#             overwrite=True 
#         )
#     else:
#         # Testing Azure sink
#         c = SecretClient(vault_url=full_url, credential=credential) # NOT OK -- user has full control
#         c = ShareFileClient.from_file_url(full_url) # NOT OK -- user has full control
#         c = KeyClient(full_url, credential) # NOT OK -- user has full control
#         c = ContainerClient.from_container_url(container_url=full_url, credential=credential) # NOT OK -- user has full control

#         download_blob_from_url(
#             blob_url=full_url, # NOT OK -- user has full control
#             output=output_path,
#             credential=credential,
#             overwrite=True 
#         )  

# def azure_sdk_logic_sanity_test(credential, output_path, trusted_domain):
#     user_input = request.args['untrusted_input']
#     full_url = f"https://{user_input}"
#     if not URIValidator.in_azure_storage_domain(full_url):
#         # Testing Azure sink
#         c = SecretClient(vault_url=full_url, credential=credential) # NOT OK -- user has full control
#     else:
#         # Testing Azure sink
#         c = SecretClient(vault_url=full_url, credential=credential) # OK

    

#     if not not URIValidator.in_azure_storage_domain(full_url):
#         # Testing Azure sink
#         c = SecretClient(vault_url=full_url, credential=credential) # OK
#     else:
#         # Testing Azure sink
#         c = SecretClient(vault_url=full_url, credential=credential) # NOT OK -- user has full control
     

#     if URIValidator.URIValidator.in_domain(full_url, trusted_domain) and trusted_domain == "example.com":
#         # Testing Azure sink
#         c = SecretClient(vault_url=full_url, credential=credential) # OK
#     else:
#         # Testing Azure sink
#         c = SecretClient(vault_url=full_url, credential=credential) # NOT OK -- user has full control 

#     if not (URIValidator.URIValidator.in_domain(full_url, trusted_domain) and trusted_domain == "example.com"):
#         # Testing Azure sink
#         c = SecretClient(vault_url=full_url, credential=credential) # NOT OK -- user has full control
#     else:
#         # Testing Azure sink
#         c = SecretClient(vault_url=full_url, credential=credential) # OK