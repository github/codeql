//package org.bouncycastle.jce.provider.test;

import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.SecureRandom;
import java.security.Security;
import java.security.Signature;

// import org.bouncycastle.asn1.cryptopro.CryptoProObjectIdentifiers;
// import org.bouncycastle.jce.provider.BouncyCastleProvider;
// import org.bouncycastle.jce.spec.ECNamedCurveGenParameterSpec;
// import org.bouncycastle.jce.spec.GOST3410ParameterSpec;
// import org.bouncycastle.util.encoders.Hex;
// import org.bouncycastle.util.test.SimpleTest;

public class SignatureTest
    //extends SimpleTest
{
    // private static final byte[] DATA = Hex.decode("00000000deadbeefbeefdeadffffffff00000000");

    private void checkSig(KeyPair kp, String name)
        throws Exception
    {
        // Signature sig = Signature.getInstance(name, "BC");

        // sig.initSign(kp.getPrivate());
        // sig.update(DATA);

        // byte[] signature1 = sig.sign();

        // sig.update(DATA);

        // byte[] signature2 = sig.sign();

        // sig.initVerify(kp.getPublic());

        // sig.update(DATA);
        // if (!sig.verify(signature1))
        // {
        //     fail("did not verify: " + name);
        // }

        // // After verify, should be reusable as if we are after initVerify
        // sig.update(DATA);
        // if (!sig.verify(signature1))
        // {
        //     fail("second verify failed: " + name);
        // }

        // sig.update(DATA);
        // if (!sig.verify(signature2))
        // {
        //     fail("second verify failed (2): " + name);
        // }
    }

    public void performTest()
        throws Exception
    {
        KeyPairGenerator kpGen = KeyPairGenerator.getInstance("RSA", "BC");

        kpGen.initialize(2048); // Safe

        KeyPair kp = kpGen.generateKeyPair();

        checkSig(kp, "SHA1withRSA");
        checkSig(kp, "SHA224withRSA");
        checkSig(kp, "SHA256withRSA");
        checkSig(kp, "SHA384withRSA");
        checkSig(kp, "SHA512withRSA");

        checkSig(kp, "SHA3-224withRSA");
        checkSig(kp, "SHA3-256withRSA");
        checkSig(kp, "SHA3-384withRSA");
        checkSig(kp, "SHA3-512withRSA");

        checkSig(kp, "MD2withRSA");
        checkSig(kp, "MD4withRSA");
        checkSig(kp, "MD5withRSA");
        checkSig(kp, "RIPEMD160withRSA");
        checkSig(kp, "RIPEMD128withRSA");
        checkSig(kp, "RIPEMD256withRSA");

        checkSig(kp, "SHA1withRSAandMGF1");
        checkSig(kp, "SHA1withRSAandMGF1");
        checkSig(kp, "SHA224withRSAandMGF1");
        checkSig(kp, "SHA256withRSAandMGF1");
        checkSig(kp, "SHA384withRSAandMGF1");
        checkSig(kp, "SHA512withRSAandMGF1");

        checkSig(kp, "SHA1withRSAandSHAKE128");
        checkSig(kp, "SHA1withRSAandSHAKE128");
        checkSig(kp, "SHA224withRSAandSHAKE128");
        checkSig(kp, "SHA256withRSAandSHAKE128");
        checkSig(kp, "SHA384withRSAandSHAKE128");
        checkSig(kp, "SHA512withRSAandSHAKE128");

        checkSig(kp, "SHA1withRSAandSHAKE256");
        checkSig(kp, "SHA1withRSAandSHAKE256");
        checkSig(kp, "SHA224withRSAandSHAKE256");
        checkSig(kp, "SHA256withRSAandSHAKE256");
        checkSig(kp, "SHA384withRSAandSHAKE256");
        checkSig(kp, "SHA512withRSAandSHAKE256");

        checkSig(kp, "SHAKE128withRSAPSS");
        checkSig(kp, "SHAKE256withRSAPSS");

        checkSig(kp, "SHA1withRSA/ISO9796-2");
        checkSig(kp, "MD5withRSA/ISO9796-2");
        checkSig(kp, "RIPEMD160withRSA/ISO9796-2");

//        checkSig(kp, "SHA1withRSA/ISO9796-2PSS");
//        checkSig(kp, "MD5withRSA/ISO9796-2PSS");
//        checkSig(kp, "RIPEMD160withRSA/ISO9796-2PSS");

        checkSig(kp, "RIPEMD128withRSA/X9.31");
        checkSig(kp, "RIPEMD160withRSA/X9.31");
        checkSig(kp, "SHA1withRSA/X9.31");
        checkSig(kp, "SHA224withRSA/X9.31");
        checkSig(kp, "SHA256withRSA/X9.31");
        checkSig(kp, "SHA384withRSA/X9.31");
        checkSig(kp, "SHA512withRSA/X9.31");
        checkSig(kp, "WhirlpoolwithRSA/X9.31");

        kpGen = KeyPairGenerator.getInstance("DSA", "BC");

        kpGen.initialize(2048); // Safe

        kp = kpGen.generateKeyPair();

        checkSig(kp, "SHA1withDSA");
        checkSig(kp, "SHA224withDSA");
        checkSig(kp, "SHA256withDSA");
        checkSig(kp, "SHA384withDSA");
        checkSig(kp, "SHA512withDSA");
        checkSig(kp, "NONEwithDSA");

        kpGen = KeyPairGenerator.getInstance("EC", "BC");

        kpGen.initialize(256); // Safe

        kp = kpGen.generateKeyPair();

        checkSig(kp, "SHA1withECDSA");
        checkSig(kp, "SHA224withECDSA");
        checkSig(kp, "SHA256withECDSA");
        checkSig(kp, "SHA384withECDSA");
        checkSig(kp, "SHA512withECDSA");
        checkSig(kp, "RIPEMD160withECDSA");
        checkSig(kp, "SHAKE128withECDSA");
        checkSig(kp, "SHAKE256withECDSA");

        kpGen = KeyPairGenerator.getInstance("EC", "BC");

        kpGen.initialize(521); // Safe

        kp = kpGen.generateKeyPair();

        checkSig(kp, "SHA1withECNR");
        checkSig(kp, "SHA224withECNR");
        checkSig(kp, "SHA256withECNR");
        checkSig(kp, "SHA384withECNR");
        checkSig(kp, "SHA512withECNR");

        // kpGen = KeyPairGenerator.getInstance("ECGOST3410", "BC");

        // kpGen.initialize(new ECNamedCurveGenParameterSpec("GostR3410-2001-CryptoPro-A"), new SecureRandom());

        // kp = kpGen.generateKeyPair();

        // checkSig(kp, "GOST3411withECGOST3410");

        // kpGen = KeyPairGenerator.getInstance("GOST3410", "BC");

        // GOST3410ParameterSpec gost3410P = new GOST3410ParameterSpec(CryptoProObjectIdentifiers.gostR3410_94_CryptoPro_A.getId());

        // kpGen.initialize(gost3410P);

        // kp = kpGen.generateKeyPair();

        // checkSig(kp, "GOST3411withGOST3410");
    }

    public String getName()
    {
        return "SigNameTest";
    }

    // public static void main(
    //     String[] args)
    // {
    //     //Security.addProvider(new BouncyCastleProvider());

    //     //runTest(new SignatureTest());
    // }
}
