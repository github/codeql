import java.security.KeyPair;
import java.security.Security;
import java.security.SecureRandom;
import org.bouncycastle.crypto.AsymmetricCipherKeyPair;
import org.bouncycastle.crypto.generators.Ed25519KeyPairGenerator;
import org.bouncycastle.crypto.params.Ed25519KeyGenerationParameters;
import org.bouncycastle.crypto.params.Ed25519PrivateKeyParameters;
import org.bouncycastle.crypto.params.Ed25519PublicKeyParameters;
import org.bouncycastle.crypto.signers.Ed25519Signer;
import org.bouncycastle.jce.provider.BouncyCastleProvider;

public class Ed25519SignAndVerify {
    public static void main(String[] args) {
        Security.addProvider(new BouncyCastleProvider());
        
        try {
            // Generate a key pair
            SecureRandom random = new SecureRandom();
            Ed25519KeyPairGenerator keyPairGenerator = new Ed25519KeyPairGenerator();
            keyPairGenerator.init(new Ed25519KeyGenerationParameters(random));
            AsymmetricCipherKeyPair keyPair = keyPairGenerator.generateKeyPair();
            
            Ed25519PrivateKeyParameters privateKey = (Ed25519PrivateKeyParameters) keyPair.getPrivate();
            Ed25519PublicKeyParameters publicKey = (Ed25519PublicKeyParameters) keyPair.getPublic();
            
            byte[] message = "Hello, Ed25519 signature!".getBytes("UTF-8");
            
            // Sign the message
            Ed25519Signer signer = new Ed25519Signer();
            signer.init(true, privateKey); // true for signing
            signer.update(message, 0, message.length);
            byte[] signature = signer.generateSignature();
            
            System.out.println("Signature generated!");
            
            // Verify the signature
            Ed25519Signer verifier = new Ed25519Signer();
            verifier.init(false, publicKey); // false for verification
            verifier.update(message, 0, message.length);
            boolean verified = verifier.verifySignature(signature);
            
            System.out.println("Signature verified: " + verified);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}