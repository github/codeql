import java.security.Security;
import java.security.SecureRandom;
import org.bouncycastle.crypto.AsymmetricCipherKeyPair;
import org.bouncycastle.crypto.generators.ECKeyPairGenerator;
import org.bouncycastle.crypto.params.ECDomainParameters;
import org.bouncycastle.crypto.params.ECKeyGenerationParameters;
import org.bouncycastle.crypto.params.ECPrivateKeyParameters;
import org.bouncycastle.crypto.params.ECPublicKeyParameters;
import org.bouncycastle.crypto.signers.ECDSASigner;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.asn1.sec.SECNamedCurves;
import org.bouncycastle.asn1.x9.X9ECParameters;

/**
 * Example of using Bouncy Castle's low-level API for ECDSA signing and verification over P-256.
 */
public class ECDSAP256SignAndVerify {
    public static void main(String[] args) {
        // Add Bouncy Castle provider
        Security.addProvider(new BouncyCastleProvider());
        
        try {
            // Get P-256 curve parameters using BouncyCastle's SECNamedCurves
            String curveName = "secp256r1";
            X9ECParameters ecParams = SECNamedCurves.getByName(curveName);
            ECDomainParameters domainParams = new ECDomainParameters(ecParams);
            
            // Generate a key pair
            SecureRandom random = new SecureRandom();
            ECKeyPairGenerator keyPairGenerator = new ECKeyPairGenerator();
            ECKeyGenerationParameters keyGenParams = new ECKeyGenerationParameters(domainParams, random);
            keyPairGenerator.init(keyGenParams);
            AsymmetricCipherKeyPair keyPair = keyPairGenerator.generateKeyPair();
            
            ECPrivateKeyParameters privateKey = (ECPrivateKeyParameters) keyPair.getPrivate();
            ECPublicKeyParameters publicKey = (ECPublicKeyParameters) keyPair.getPublic();
            
            byte[] message = "Hello, ECDSA P-256 signature!".getBytes("UTF-8");
            
            // Sign the message
            ECDSASigner signer = new ECDSASigner();
            signer.init(true, privateKey); // true for signing
            // Note: ECDSA typically signs a hash of the message, not the message directly
            // For simplicity, we're signing the message bytes directly here
            java.math.BigInteger[] signature = signer.generateSignature(message);
            
            System.out.println("Signature generated!");
            System.out.println("Signature r: " + signature[0].toString(16));
            System.out.println("Signature s: " + signature[1].toString(16));
            
            // Verify the signature
            ECDSASigner verifier = new ECDSASigner();
            verifier.init(false, publicKey); // false for verification
            boolean verified = verifier.verifySignature(message, signature[0], signature[1]);
            
            System.out.println("Signature verified: " + verified);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}