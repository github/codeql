These tests are a copy of the tests in [../cryptodome](../cryptodome) with `Cryptodome` replaced by `Crypto`.

You can run the following command to update the tests:

```sh
rm *.py && cp ../cryptodome/*.py . && sed -i -e 's/Cryptodome/Crypto/' *.py
```

The original [`pycrypto` PyPI package](https://pypi.org/project/pycrypto/) that provided the `Crypto` Python package has not been updated since 2013, so it is reasonable to assume that people will use the replacement [`pycryptodome` PyPI package](https://pypi.org/project/pycryptodome/) that also provides a `Crypto` Python package and has a (mostly) compatible API.

The pycryptodome functionality is also available in the [`pycryptodomex` PyPI package](https://pypi.org/project/pycryptodomex/) which provides the `Cryptodome` Python package.

To ensure our modeling actually covers _both_ ways of importing the same functionality, we have this convoluted test setup.
