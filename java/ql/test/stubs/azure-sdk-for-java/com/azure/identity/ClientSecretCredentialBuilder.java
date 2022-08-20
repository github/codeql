// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.azure.identity;

/**
 * Fluent credential builder for instantiating a {@link ClientSecretCredential}.
 *
 * @see ClientSecretCredential
 */
public class ClientSecretCredentialBuilder extends AadCredentialBuilderBase<ClientSecretCredentialBuilder> {
    /**
     * Sets the client secret for the authentication.
     * @param clientSecret the secret value of the AAD application.
     * @return An updated instance of this builder.
     */
    public ClientSecretCredentialBuilder clientSecret(String clientSecret) {
        return null;
    }

    /**
     * Enables the shared token cache which is disabled by default. If enabled, the credential will store tokens
     * in a cache persisted to the machine, protected to the current user, which can be shared by other credentials
     * and processes.
     *
     * @return An updated instance of this builder.
     */
    ClientSecretCredentialBuilder enablePersistentCache() {
        return null;
    }

    /**
     * Allows to use an unprotected file specified by <code>cacheFileLocation()</code> instead of
     * Gnome keyring on Linux. This is restricted by default.
     *
     * @return An updated instance of this builder.
     */
    ClientSecretCredentialBuilder allowUnencryptedCache() {
        return null;
    }

    /**
     * Configures the persistent shared token cache options and enables the persistent token cache which is disabled
     * by default. If configured, the credential will store tokens in a cache persisted to the machine, protected to
     * the current user, which can be shared by other credentials and processes.
     *
     * @param tokenCachePersistenceOptions the token cache configuration options
     * @return An updated instance of this builder with the token cache options configured.
     */
    public ClientSecretCredentialBuilder tokenCachePersistenceOptions(TokenCachePersistenceOptions
                                                                                tokenCachePersistenceOptions) {
        return null;
    }

    /**
     * Creates a new {@link ClientCertificateCredential} with the current configurations.
     *
     * @return a {@link ClientSecretCredentialBuilder} with the current configurations.
     */
    public ClientSecretCredential build() {
        return null;
    }
}
