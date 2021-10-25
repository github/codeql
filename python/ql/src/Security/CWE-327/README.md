# Current status (Feb 2021)

This should be kept up to date; the world is moving fast and protocols are being broken.

## Protocols

- All versions of SSL are insecure
- TLS 1.0 and TLS 1.1 are insecure
- TLS 1.2 have some issues. but TLS 1.3 is not widely supported

## Conection methods

- `ssl.wrap_socket` is creating insecure connections, use `SSLContext.wrap_socket` instead. [link](https://docs.python.org/3/library/ssl.html#ssl.wrap_socket)
    > Deprecated since version 3.7: Since Python 3.2 and 2.7.9, it is recommended to use the `SSLContext.wrap_socket()` instead of `wrap_socket()`. The top-level function is limited and creates an insecure client socket without server name indication or hostname matching.
- Default constructors are fine, a fluent API is used to constrain possible protocols later.

## Current recomendation

TLS 1.2 or TLS 1.3

## Queries

- `InsecureProtocol` detects uses of insecure protocols.
- `InsecureDefaultProtocol` detect default constructions, this is no longer unsafe.
