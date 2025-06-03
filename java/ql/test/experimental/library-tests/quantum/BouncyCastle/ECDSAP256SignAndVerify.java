import java.security.Security;
import java.security.SecureRandom;
import java.security.interfaces.ECPrivateKey;
import java.security.interfaces.ECPublicKey;
import org.bouncycastle.crypto.AsymmetricCipherKeyPair;
import org.bouncycastle.crypto.generators.ECKeyPairGenerator;
import org.bouncycastle.crypto.params.ECDomainParameters;
import org.bouncycastle.crypto.params.ECKeyGenerationParameters;
import org.bouncycastle.crypto.params.ECPrivateKeyParameters;
import org.bouncycastle.crypto.params.ECPublicKeyParameters;
import org.bouncycastle.crypto.signers.ECDSASigner;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.jce.spec.ECNamedCurveParameterSpec;
import org.bouncycastle.jce.spec.ECNamedCurveSpec;
import org.bouncycastle.jce.ECNamedCurveTable;
import org.bouncycastle.asn1.sec.SECNamedCurves;
import org.bouncycastle.asn1.x9.X9ECParameters;
import org.bouncycastle.math.ec.ECCurve;
import org.bouncycastle.math.ec.ECPoint;

/**
 * Test Bouncy Castle's low-level ECDSA API
 */
public class ECDSAP256SignAndVerify {
    
    public static void main(String[] args) {
        // Add Bouncy Castle provider
        Security.addProvider(new BouncyCastleProvider());
        
        try {
            byte[] message = "Hello, ECDSA P-256 signature!".getBytes("UTF-8");
            
            // Test different key generation methods
            signWithKeyPair(generateKeyPair1(), message);
            signWithKeyPair(generateKeyPair2(), message);
            signWithKeyPair(generateKeyPair3(), message);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Method 1: Generate key pair with SECNamedCurves
     */
    private static AsymmetricCipherKeyPair generateKeyPair1() throws Exception {
        // Get P-256 curve parameters using BouncyCastle's SECNamedCurves
        String curveName = "secp256r1";
        X9ECParameters ecParams = SECNamedCurves.getByName(curveName);
        ECDomainParameters domainParams = new ECDomainParameters(ecParams);
        
        // Generate a key pair
        SecureRandom random = new SecureRandom();
        ECKeyPairGenerator keyPairGenerator = new ECKeyPairGenerator();
        ECKeyGenerationParameters keyGenParams = new ECKeyGenerationParameters(domainParams, random);
        keyPairGenerator.init(keyGenParams);
        
        return keyPairGenerator.generateKeyPair();
    }

    /**
     * Method 2: Generate key pair with explicit curve construction
     */
    private static AsymmetricCipherKeyPair generateKeyPair2() throws Exception {
        // Get the X9.62 parameters and construct domain parameters explicitly
        String curveName = "secp256k1";
        X9ECParameters x9Params = SECNamedCurves.getByName(curveName);
        ECCurve curve = x9Params.getCurve();
        ECPoint g = x9Params.getG();
        java.math.BigInteger n = x9Params.getN();
        java.math.BigInteger h = x9Params.getH();
        
        // Create domain parameters with explicit values
        ECDomainParameters domainParams = new ECDomainParameters(curve, g, n, h);
        
        SecureRandom random = new SecureRandom();
        ECKeyPairGenerator keyPairGenerator = new ECKeyPairGenerator();
        ECKeyGenerationParameters keyGenParams = new ECKeyGenerationParameters(domainParams, random);
        keyPairGenerator.init(keyGenParams);
        
        return keyPairGenerator.generateKeyPair();
    }

    
    /**
     * Method 3: Generate key pair using ECNamedCurveTable 
     */
    private static AsymmetricCipherKeyPair generateKeyPair3() throws Exception {
        // Get curve parameters using ECNamedCurveTable
        String curveName = "secp384r1";
        ECNamedCurveParameterSpec ecSpec = ECNamedCurveTable.getParameterSpec(curveName);
        ECDomainParameters domainParams = new ECDomainParameters(
            ecSpec.getCurve(), 
            ecSpec.getG(), 
            ecSpec.getN(), 
            ecSpec.getH()
        );
        
        SecureRandom random = new SecureRandom();
        ECKeyPairGenerator keyPairGenerator = new ECKeyPairGenerator();
        ECKeyGenerationParameters keyGenParams = new ECKeyGenerationParameters(domainParams, random);
        keyPairGenerator.init(keyGenParams);
        
        return keyPairGenerator.generateKeyPair();
    }
    
    /**
     * Test signing and verification with BouncyCastle low-level key pair
     */
    private static void signWithKeyPair(AsymmetricCipherKeyPair keyPair, byte[] message) throws Exception {
        ECPrivateKeyParameters privateKey = (ECPrivateKeyParameters) keyPair.getPrivate();
        ECPublicKeyParameters publicKey = (ECPublicKeyParameters) keyPair.getPublic();
        
        // Sign the message
        ECDSASigner signer = new ECDSASigner();
        signer.init(true, privateKey); // true for signing
        java.math.BigInteger[] signature = signer.generateSignature(message);
        
        // Verify the signature
        ECDSASigner verifier = new ECDSASigner();
        verifier.init(false, publicKey); // false for verification
        boolean verified = verifier.verifySignature(message, signature[0], signature[1]);
    }
}