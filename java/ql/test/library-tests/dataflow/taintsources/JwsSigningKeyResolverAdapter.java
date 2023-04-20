import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwsHeader;
import io.jsonwebtoken.SigningKeyResolverAdapter;

public class JwsSigningKeyResolverAdapter extends SigningKeyResolverAdapter {
    private void sink(Object o) {
    }

    @Override
    public byte[] resolveSigningKeyBytes(JwsHeader header, Claims claims) {
        final String keyId = header.getKeyId();
        String example = "example:" + keyId;
        sink(example); // $ hasRemoteTaintFlow

        return new byte[0];
    }
}
