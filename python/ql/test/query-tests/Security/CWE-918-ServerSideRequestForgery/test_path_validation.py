from azure.keyvault.secrets import SecretClient
from azure.storage.fileshare import ShareFileClient
from azure.keyvault.keys import KeyClient
from AntiSSRF import URIValidator
from flask import request # $ Source

def urivalidator_path_in_domain_validation(credential, trusted_domain):
    user_input = request.args['untrusted_input']
    user_input2 = request.args['untrusted_input2']
    url = f"https://example.com/foo#{user_input}"
    full_url = f"https://{user_input2}"

    if URIValidator.in_domain(url, trusted_domain):
        c = SecretClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]
    else:
        c = SecretClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]

    if URIValidator.in_domain(full_url, trusted_domain):
        c = SecretClient(vault_url=full_url, credential=credential) # $ Alert[py/partial-ssrf]
    else:
        c = SecretClient(vault_url=full_url, credential=credential) # $ Alert[py/full-ssrf]

def urivalidator_path_in_azure_keyvault_domain_validation(credential):
    user_input = request.args['untrusted_input']
    user_input2 = request.args['untrusted_input2']
    url = f"https://example.com/foo#{user_input}"
    full_url = f"https://{user_input2}"

    if URIValidator.in_azure_keyvault_domain(url):
        c = KeyClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]
    else:
        c = KeyClient(vault_url=url, credential=credential)  # $ Alert[py/partial-ssrf]

    if URIValidator.in_azure_keyvault_domain(full_url):
        c = KeyClient(vault_url=full_url, credential=credential)  # $ Alert[py/partial-ssrf]
    else:
        c = KeyClient(vault_url=full_url, credential=credential)  # $ Alert[py/full-ssrf]

def urivalidator_path_in_azure_storage_domain_validation(credential):
    user_input = request.args['untrusted_input']
    user_input2 = request.args['untrusted_input2']
    url = f"https://example.com/foo#{user_input}"
    full_url = f"https://{user_input2}"

    if URIValidator.in_azure_storage_domain(url):
        c = ShareFileClient.from_file_url(url) # $ Alert[py/partial-ssrf]
    else:
        c = ShareFileClient.from_file_url(url) # $ Alert[py/partial-ssrf]

    if URIValidator.in_azure_storage_domain(full_url):
        c = ShareFileClient.from_file_url(full_url) # $ Alert[py/partial-ssrf]
    else:
        c = ShareFileClient.from_file_url(full_url) # $ Alert[py/full-ssrf]


def complex_urivalidator_checks(credential, trusted_domain):
    user_input = request.args['untrusted_input']
    # Focus on in_domain only here for simplicity
    # It assumed the logic underlying checking paths would apply 
    # similarly other validator methods
    url = f"https://{user_input}"

    if not URIValidator.in_domain(url, trusted_domain):
        c = SecretClient(vault_url=url, credential=credential) # $ Alert[py/full-ssrf]
    else:
        c = SecretClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]

    if URIValidator.in_domain(url, trusted_domain) and trusted_domain == "example.com":
        c = SecretClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]
    else:
        c = SecretClient(vault_url=url, credential=credential) # $ Alert[py/full-ssrf]

    if not (URIValidator.in_domain(url, trusted_domain) and trusted_domain == "example.com"):
        c = SecretClient(vault_url=url, credential=credential) # $ Alert[py/full-ssrf]
    else:
        c = SecretClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]

    if not not not URIValidator.in_domain(url, trusted_domain):
        c = SecretClient(vault_url=url, credential=credential) # $ Alert[py/full-ssrf]
    else:
        c = SecretClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]


    if URIValidator.in_domain(url, trusted_domain) == True:
        c = SecretClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]
    else:
        c = SecretClient(vault_url=url, credential=credential) # $ Alert[py/full-ssrf]

    if URIValidator.in_domain(url, trusted_domain) == False:
        c = SecretClient(vault_url=url, credential=credential) # $ Alert[py/full-ssrf]
    else:
        c = SecretClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]

    if URIValidator.in_domain(url, trusted_domain) != True:
        c = SecretClient(vault_url=url, credential=credential) # $ Alert[py/full-ssrf]
    else:
        c = SecretClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]

    if URIValidator.in_domain(url, trusted_domain) != False:
        c = SecretClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]
    else:
        c = SecretClient(vault_url=url, credential=credential) # $ Alert[py/full-ssrf]

    if URIValidator.in_domain(url, trusted_domain) is True:
        c = SecretClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]
    else:
        c = SecretClient(vault_url=url, credential=credential) # $ Alert[py/full-ssrf]

    if URIValidator.in_domain(url, trusted_domain) is False:
        c = SecretClient(vault_url=url, credential=credential) # $ Alert[py/full-ssrf]
    else:
        c = SecretClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]

    if URIValidator.in_domain(url, trusted_domain) is not True:
        c = SecretClient(vault_url=url, credential=credential) # $ Alert[py/full-ssrf]
    else:
        c = SecretClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]

    if URIValidator.in_domain(url, trusted_domain) is not False:
        c = SecretClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]
    else:
        c = SecretClient(vault_url=url, credential=credential) # $ Alert[py/full-ssrf]

    if not URIValidator.in_domain(url, trusted_domain) is True:
        c = SecretClient(vault_url=url, credential=credential) # $ Alert[py/full-ssrf]
    else:
        c = SecretClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]

    if not URIValidator.in_domain(url, trusted_domain) is False:
        c = SecretClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]
    else:
        c = SecretClient(vault_url=url, credential=credential) # $ Alert[py/full-ssrf]