// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.azure.identity;

import com.azure.core.credential.TokenCredential;

/**
 * An AAD credential that acquires a token with a username and a password. Users with 2FA/MFA (Multi-factored auth)
 * turned on will not be able to use this credential. Please use {@link DeviceCodeCredential} or {@link
 * InteractiveBrowserCredential} instead, or create a service principal if you want to authenticate silently.
 */
public class UsernamePasswordCredential implements TokenCredential {
}
