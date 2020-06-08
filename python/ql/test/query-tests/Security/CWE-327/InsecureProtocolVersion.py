import ssl

def get_ssl_context():
  ctx = ssl.SSLContext(ssl.PROTOCOL_TLS)  # lgtm[py/insecure-protocol], TODO see https://github.com/Semmle/ql/issues/2554
  ctx.options |= ssl.OP_NO_TLSv1  # TLSv1.0 is insecure
  ctx.load_cert_chain("cert_file", keyfile="key_file")
  # ctx.load_verify_locations(cafile="root_ca_file")
  # ctx.verify_mode = ssl.CERT_NONE  # we accept self-signed certificates as does Apple
  return ctx