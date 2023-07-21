import ssl

secure_context = ssl.SSLContext(ssl.PROTOCOL_TLS)
secure_context.options |= ssl.OP_NO_TLSv1 | ssl.OP_NO_TLSv1_1

# this is just to allow us to see how un-altered exports work
completely_insecure_context = ssl.SSLContext(ssl.PROTOCOL_TLS)

# and an insecure export that is refined
also_insecure_context = ssl.SSLContext(ssl.PROTOCOL_TLS)
also_insecure_context.options |= ssl.OP_NO_TLSv1
