import java.security.SecureRandom;
import org.bouncycastle.crypto.AsymmetricCipherKeyPair;
import org.bouncycastle.pqc.crypto.lms.LMSKeyPairGenerator;
import org.bouncycastle.pqc.crypto.lms.LMSKeyGenerationParameters;
import org.bouncycastle.pqc.crypto.lms.LMSParameters;
import org.bouncycastle.pqc.crypto.lms.LMSPrivateKeyParameters;
import org.bouncycastle.pqc.crypto.lms.LMSPublicKeyParameters;
import org.bouncycastle.pqc.crypto.lms.LMSSigner;
import org.bouncycastle.pqc.crypto.lms.LMSigParameters;
import org.bouncycastle.pqc.crypto.lms.LMOtsParameters;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import java.security.Security;

/**
 * Example of the Leighton-Micali Signature (LMS) scheme using Bouncy Castle's
 * low-level API.
 * 
 */
public class LMSSignature {
    public static void main(String[] args) {
        Security.addProvider(new BouncyCastleProvider());
        
        try {
            // Set up LMS parameters
            LMSParameters lmsParameters = new LMSParameters(
                    LMSigParameters.lms_sha256_n32_h10,
                    LMOtsParameters.sha256_n32_w8);
            
            // Generate key pair
            SecureRandom random = new SecureRandom();
            LMSKeyPairGenerator keyPairGen = new LMSKeyPairGenerator();
            keyPairGen.init(new LMSKeyGenerationParameters(lmsParameters, random));
            AsymmetricCipherKeyPair keyPair = keyPairGen.generateKeyPair();
            
            LMSPrivateKeyParameters privateKey = (LMSPrivateKeyParameters) keyPair.getPrivate();
            LMSPublicKeyParameters publicKey = (LMSPublicKeyParameters) keyPair.getPublic();
            
            byte[] message = "Hello, LMS signature!".getBytes("UTF-8");
            
            LMSSigner signer = new LMSSigner();
            
            // Sign the message
            signer.init(true, privateKey); // true for signing
            byte[] signature = signer.generateSignature(message);
            
            // Verify the signature
            //
            // TODO: Using the same signer instance for verification causes both
            // keys to be reported. This should be handled using dataflow.
            signer.init(false, publicKey);   
            boolean verified = signer.verifySignature(message, signature);
            
            System.out.println("Signature verified: " + verified);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}