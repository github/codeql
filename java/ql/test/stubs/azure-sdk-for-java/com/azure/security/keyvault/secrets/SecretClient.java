// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.azure.security.keyvault.secrets;

import com.azure.security.keyvault.secrets.models.KeyVaultSecret;
import com.azure.security.keyvault.secrets.models.SecretProperties;

/**
 * The SecretClient provides synchronous methods to manage {@link KeyVaultSecret secrets} in the Azure Key Vault. The client
 * supports creating, retrieving, updating, deleting, purging, backing up, restoring, and listing the {@link KeyVaultSecret
 * secrets}. The client also supports listing {@link DeletedSecret deleted secrets} for a soft-delete enabled Azure Key
 * Vault.
 *
 * <p><strong>Construct the sync client</strong></p>
 * {@codesnippet com.azure.security.keyvault.secretclient.sync.construct}
 *
 * @see SecretClientBuilder
 * @see PagedIterable
 */
public final class SecretClient {

    /**
     * Gets the vault endpoint url to which service requests are sent to.
     * @return the vault endpoint url.
     */
    public String getVaultUrl() {
        return null;
    }

    /**
     * Adds a secret to the key vault if it does not exist. If the named secret exists, a new version of the secret is
     * created. This operation requires the {@code secrets/set} permission.
     *
     * <p>The {@link SecretProperties#getExpiresOn() expires}, {@link SecretProperties#getContentType() contentType},
     * and {@link SecretProperties#getNotBefore() notBefore} values in {@code secret} are optional.
     * If not specified, {@link SecretProperties#isEnabled() enabled} is set to true by key vault.</p>
     *
     * <p><strong>Code sample</strong></p>
     * <p>Creates a new secret in the key vault. Prints out the details of the newly created secret returned in the
     * response.</p>
     * {@codesnippet com.azure.security.keyvault.secretclient.setSecret#secret}
     *
     * @param secret The Secret object containing information about the secret and its properties. The properties
     *     {@link KeyVaultSecret#getName() secret.name} and {@link KeyVaultSecret#getValue() secret.value} cannot be
     *     null.
     * @return The {@link KeyVaultSecret created secret}.
     * @throws NullPointerException if {@code secret} is {@code null}.
     * @throws ResourceModifiedException if {@code secret} is malformed.
     * @throws HttpResponseException if {@link KeyVaultSecret#getName() name} or {@link KeyVaultSecret#getValue() value}
     *     is an empty string.
     */
    public KeyVaultSecret setSecret(KeyVaultSecret secret) {
        return null;
    }

    /**
     * Adds a secret to the key vault if it does not exist. If the named secret exists, a new version of the secret is
     * created. This operation requires the {@code secrets/set} permission.
     *
     * <p><strong>Code sample</strong></p>
     * <p>Creates a new secret in the key vault. Prints out the details of the newly created secret returned in the
     * response.</p>
     * {@codesnippet com.azure.security.keyvault.secretclient.setSecret#string-string}
     *
     * @param name The name of the secret. It is required and cannot be null.
     * @param value The value of the secret. It is required and cannot be null.
     * @return The {@link KeyVaultSecret created secret}.
     * @throws ResourceModifiedException if invalid {@code name} or {@code value} is specified.
     * @throws HttpResponseException if {@code name} or {@code value} is empty string.
     */
    public KeyVaultSecret setSecret(String name, String value) {
        return null;
    }

    /**
     * Gets the specified secret with specified version from the key vault. This operation requires the
     * {@code secrets/get} permission.
     *
     * <p><strong>Code sample</strong></p>
     * <p>Gets a specific version of the secret in the key vault. Prints out the details of the returned secret.</p>
     * {@codesnippet com.azure.security.keyvault.secretclient.getSecret#string-string}
     *
     * @param name The name of the secret, cannot be null.
     * @param version The version of the secret to retrieve. If this is an empty string or null, this call is
     *     equivalent to calling {@link #getSecret(String)}, with the latest version being retrieved.
     * @return The requested {@link KeyVaultSecret secret}.
     * @throws ResourceNotFoundException when a secret with {@code name} and {@code version} doesn't exist in the
     *     key vault.
     * @throws HttpResponseException if {@code name} or {@code version} is empty string.
     */
    public KeyVaultSecret getSecret(String name, String version) {
        return null;
    }

    /**
     * Gets the latest version of the specified secret from the key vault.
     * This operation requires the {@code secrets/get} permission.
     *
     * <p><strong>Code sample</strong></p>
     * <p>Gets the latest version of the secret in the key vault. Prints out the details of the returned secret.</p>
     * {@codesnippet com.azure.security.keyvault.secretclient.getSecret#string}
     *
     * @param name The name of the secret.
     * @return The requested {@link KeyVaultSecret}.
     * @throws ResourceNotFoundException when a secret with {@code name} doesn't exist in the key vault.
     * @throws HttpResponseException if {@code name} is empty string.
     */
    public KeyVaultSecret getSecret(String name) {
        return null;
    }

    /**
     * Updates the attributes associated with the secret. The value of the secret in the key vault cannot be changed.
     * Only attributes populated in {@code secretProperties} are changed. Attributes not specified in the request are
     * not changed. This operation requires the {@code secrets/set} permission.
     *
     * <p>The {@code secret} is required and its fields {@link SecretProperties#getName() name} and
     * {@link SecretProperties#getVersion() version} cannot be null.</p>
     *
     * <p><strong>Code sample</strong></p>
     * <p>Gets the latest version of the secret, changes its expiry time, and the updates the secret in the key
     * vault.</p>
     * {@codesnippet com.azure.security.keyvault.secretclient.updateSecretProperties#secretProperties}
     *
     * @param secretProperties The {@link SecretProperties secret properties} object with updated properties.
     * @return The {@link SecretProperties updated secret}.
     * @throws NullPointerException if {@code secret} is {@code null}.
     * @throws ResourceNotFoundException when a secret with {@link SecretProperties#getName() name} and {@link
     *     SecretProperties#getVersion() version} doesn't exist in the key vault.
     * @throws HttpResponseException if {@link SecretProperties#getName() name} or {@link SecretProperties#getVersion() version} is
     *     empty string.
     */
    public SecretProperties updateSecretProperties(SecretProperties secretProperties) {
        return null;
    }

    /**
     * Requests a backup of the secret be downloaded to the client. All versions of the secret will be downloaded.
     * This operation requires the {@code secrets/backup} permission.
     *
     * <p><strong>Code sample</strong></p>
     * <p>Backs up the secret from the key vault and prints out the length of the secret's backup byte array returned in
     * the response</p>
     * {@codesnippet com.azure.security.keyvault.secretclient.backupSecret#string}
     *
     * @param name The name of the secret.
     * @return A {@link Response} whose {@link Response#getValue() value} contains the backed up secret blob.
     * @throws ResourceNotFoundException when a secret with {@code name} doesn't exist in the key vault.
     * @throws HttpResponseException when a secret with {@code name} is empty string.
     */
    public byte[] backupSecret(String name) {
        return null;
    }
}
