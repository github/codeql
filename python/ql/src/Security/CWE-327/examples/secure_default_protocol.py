import ssl

# Using flags to restrict the protocol
context = ssl.SSLContext()
context.options |= ssl.OP_NO_TLSv1 | ssl.OP_NO_TLSv1_1

# Declaring a minimum version to restrict the protocol
context = ssl.create_default_context()
context.minimum_version = ssl.TLSVersion.TLSv1_2
