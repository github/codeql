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
        SecretClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]
    else:
        SecretClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]

    if URIValidator.in_domain(full_url, trusted_domain):
        SecretClient(vault_url=full_url, credential=credential) # $ Alert[py/partial-ssrf]
    else:
        SecretClient(vault_url=full_url, credential=credential) # $ Alert[py/full-ssrf]

def urivalidator_path_in_azure_keyvault_domain_validation(credential):
    user_input = request.args['untrusted_input']
    user_input2 = request.args['untrusted_input2']
    url = f"https://example.com/foo#{user_input}"
    full_url = f"https://{user_input2}"

    if URIValidator.in_azure_keyvault_domain(url):
        KeyClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]
    else:
        KeyClient(vault_url=url, credential=credential)  # $ Alert[py/partial-ssrf]

    if URIValidator.in_azure_keyvault_domain(full_url):
        KeyClient(vault_url=full_url, credential=credential)  # $ Alert[py/partial-ssrf]
    else:
        KeyClient(vault_url=full_url, credential=credential)  # $ Alert[py/full-ssrf]

def urivalidator_path_in_azure_storage_domain_validation(credential):
    user_input = request.args['untrusted_input']
    user_input2 = request.args['untrusted_input2']
    url = f"https://example.com/foo#{user_input}"
    full_url = f"https://{user_input2}"

    if URIValidator.in_azure_storage_domain(url):
        ShareFileClient.from_file_url(url) # $ Alert[py/partial-ssrf]
    else:
        ShareFileClient.from_file_url(url) # $ Alert[py/partial-ssrf]

    if URIValidator.in_azure_storage_domain(full_url):
        ShareFileClient.from_file_url(full_url) # $ Alert[py/partial-ssrf]
    else:
        ShareFileClient.from_file_url(full_url) # $ Alert[py/full-ssrf]


def complex_urivalidator_checks(credential, trusted_domain):
    user_input = request.args['untrusted_input']
    # Focus on in_domain only here for simplicity
    # It is assumed that the logic underlying path checking would apply
    # similarly to other validator methods.
    url = f"https://{user_input}"

    if not URIValidator.in_domain(url, trusted_domain):
        SecretClient(vault_url=url, credential=credential) # $ Alert[py/full-ssrf]
    else:
        SecretClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]

    if URIValidator.in_domain(url, trusted_domain) and trusted_domain == "example.com":
        SecretClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]
    else:
        SecretClient(vault_url=url, credential=credential) # $ Alert[py/full-ssrf]

    if not (URIValidator.in_domain(url, trusted_domain) and trusted_domain == "example.com"):
        SecretClient(vault_url=url, credential=credential) # $ Alert[py/full-ssrf]
    else:
        SecretClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]

    if not not not URIValidator.in_domain(url, trusted_domain):
        SecretClient(vault_url=url, credential=credential) # $ Alert[py/full-ssrf]
    else:
        SecretClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]


    if URIValidator.in_domain(url, trusted_domain) == True:
        SecretClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]
    else:
        SecretClient(vault_url=url, credential=credential) # $ Alert[py/full-ssrf]

    if URIValidator.in_domain(url, trusted_domain) == False:
        SecretClient(vault_url=url, credential=credential) # $ Alert[py/full-ssrf]
    else:
        SecretClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]

    if URIValidator.in_domain(url, trusted_domain) != True:
        SecretClient(vault_url=url, credential=credential) # $ Alert[py/full-ssrf]
    else:
        SecretClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]

    if URIValidator.in_domain(url, trusted_domain) != False:
        SecretClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]
    else:
        SecretClient(vault_url=url, credential=credential) # $ Alert[py/full-ssrf]

    if URIValidator.in_domain(url, trusted_domain) is True:
        SecretClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]
    else:
        SecretClient(vault_url=url, credential=credential) # $ Alert[py/full-ssrf]

    if URIValidator.in_domain(url, trusted_domain) is False:
        SecretClient(vault_url=url, credential=credential) # $ Alert[py/full-ssrf]
    else:
        SecretClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]

    if URIValidator.in_domain(url, trusted_domain) is not True:
        SecretClient(vault_url=url, credential=credential) # $ Alert[py/full-ssrf]
    else:
        SecretClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]

    if URIValidator.in_domain(url, trusted_domain) is not False:
        SecretClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]
    else:
        SecretClient(vault_url=url, credential=credential) # $ Alert[py/full-ssrf]

    if not URIValidator.in_domain(url, trusted_domain) is True:
        SecretClient(vault_url=url, credential=credential) # $ Alert[py/full-ssrf]
    else:
        SecretClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]

    if not URIValidator.in_domain(url, trusted_domain) is False:
        SecretClient(vault_url=url, credential=credential) # $ Alert[py/partial-ssrf]
    else:
        SecretClient(vault_url=url, credential=credential) # $ Alert[py/full-ssrf]