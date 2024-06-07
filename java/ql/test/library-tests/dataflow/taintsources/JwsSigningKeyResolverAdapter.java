import java.security.Key;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwsHeader;
import io.jsonwebtoken.SigningKeyResolverAdapter;

public class JwsSigningKeyResolverAdapter extends SigningKeyResolverAdapter {
    private void sink(Object o) {
    }

    @Override
    public Key resolveSigningKey(JwsHeader header, Claims claims) {
        final String keyId = header.getKeyId();
        String example = "example:" + keyId;
        sink(example); // $ hasRemoteTaintFlow
        return null;
    }

    @Override
    public byte[] resolveSigningKeyBytes(JwsHeader header, Claims claims) {
        final String keyId = header.getKeyId();
        String example = "example:" + keyId;

        sink(example); // $ hasRemoteTaintFlow

        final String algorithm = header.getAlgorithm();
        sink("algo:" + algorithm); // $ hasRemoteTaintFlow

        final String random = (String)header.get("random");
        sink("random:" + random) ; // $ hasRemoteTaintFlow

        return new byte[0];
    }
}
