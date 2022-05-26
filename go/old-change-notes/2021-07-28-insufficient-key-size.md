lgtm,codescanning
* Query "Use of a weak cryptographic key" (`go/insufficient-key-size`) is promoted from experimental status. This checks that any RSA keys which are generated have a size of at least 2048 bits.
