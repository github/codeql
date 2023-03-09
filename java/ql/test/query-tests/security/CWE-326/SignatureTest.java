/* Adds tests to check for FPs related to RSA/DSA versus EC */

import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.SecureRandom;
import java.security.Security;
import java.security.Signature;

public class SignatureTest
{

    public void performTest()
        throws Exception
    {
        KeyPairGenerator kpGen = KeyPairGenerator.getInstance("RSA", "BC");
        kpGen.initialize(2048); // Safe
        KeyPair kp = kpGen.generateKeyPair();

        kpGen = KeyPairGenerator.getInstance("DSA", "BC");
        kpGen.initialize(2048); // Safe
        kp = kpGen.generateKeyPair();

        kpGen = KeyPairGenerator.getInstance("EC", "BC");
        kpGen.initialize(256); // Safe
        kp = kpGen.generateKeyPair();

        kpGen = KeyPairGenerator.getInstance("EC", "BC");
        kpGen.initialize(521); // Safe
        kp = kpGen.generateKeyPair();
    }
}
