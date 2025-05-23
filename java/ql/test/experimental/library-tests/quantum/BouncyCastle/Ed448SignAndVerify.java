import java.security.KeyPair;
import java.security.Security;
import java.security.SecureRandom;
import org.bouncycastle.crypto.AsymmetricCipherKeyPair;
import org.bouncycastle.crypto.generators.Ed448KeyPairGenerator;
import org.bouncycastle.crypto.params.Ed448KeyGenerationParameters;
import org.bouncycastle.crypto.params.Ed448PrivateKeyParameters;
import org.bouncycastle.crypto.params.Ed448PublicKeyParameters;
import org.bouncycastle.crypto.signers.Ed448Signer;
import org.bouncycastle.jce.provider.BouncyCastleProvider;

public class Ed448SignAndVerify {
    public static void main(String[] args) {
        Security.addProvider(new BouncyCastleProvider());
        
        try {
            // Generate a key pair
            SecureRandom random = new SecureRandom();
            Ed448KeyPairGenerator keyPairGenerator = new Ed448KeyPairGenerator();
            keyPairGenerator.init(new Ed448KeyGenerationParameters(random));
            AsymmetricCipherKeyPair keyPair = keyPairGenerator.generateKeyPair();
            
            Ed448PrivateKeyParameters privateKey = (Ed448PrivateKeyParameters) keyPair.getPrivate();
            Ed448PublicKeyParameters publicKey = (Ed448PublicKeyParameters) keyPair.getPublic();
            
            byte[] message = "Hello, Ed448 signature!".getBytes("UTF-8");
            
            // Sign the message
            Ed448Signer signer = new Ed448Signer("context".getBytes());
            signer.init(true, privateKey); // true for signing
            signer.update(message, 0, message.length);
            byte[] signature = signer.generateSignature();
            
            System.out.println("Signature generated!");
            
            // Verify the signature
            Ed448Signer verifier = new Ed448Signer("context".getBytes());
            verifier.init(false, publicKey); // false for verification
            verifier.update(message, 0, message.length);
            boolean verified = verifier.verifySignature(signature);
            
            System.out.println("Signature verified: " + verified);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}