import python
import semmle.python.ApiGraphs

module PycaCryptographyModule {
    import Language

    /**
       * Gets a predefined curve class constructor call from
       * `cryptography.hazmat.primitives.asymmetric.ec`
       * https://cryptography.io/en/latest/hazmat/primitives/asymmetric/ec/#elliptic-curves
       */
      DataFlow::Node predefinedCurveClass(string rawName, string curveName, Crypto::TEllipticCurveFamilyType family, int keySize) {
        // getACall since the typical case is to construct the curve with initialization values,
        // not to pass the mode uninitialized
        result =
            API::moduleImport("cryptography")
                .getMember("hazmat")
                .getMember("primitives")
                .getMember("asymmetric")
                .getMember("ec")
                .getMember(rawName)
                .getACall() 
            and
            curveName = rawName.toUpperCase()
            and
            curveName.matches("SEC%") and family instanceof Crypto::SEC
            and
            curveName.matches("BRAINPOOL%") and family instanceof Crypto::BRAINPOOL
            and
            // Enumerating all key sizes known in the API
            // TODO: should we dynamically extract them through a regex? 
            keySize in  [160, 163, 192, 224, 233, 256, 283, 320, 384, 409, 512, 571] 
            and 
            curveName.matches("%" + keySize + "%")
      }

   
      class EllipticCurve extends Crypto::EllipticCurve instanceof Expr{
        int keySize;
        string rawName;
        string curveName;
        Crypto::TEllipticCurveFamilyType family;
        EllipticCurve() {
          this = predefinedCurveClass(rawName, curveName, family, keySize).asExpr()
        }

        override string getRawAlgorithmName() { result = rawName }
        override string getAlgorithmName() { result = curveName }
        Crypto::TEllipticCurveFamilyType getFamily() { result = family }

        override string getKeySize(Location location) { 
          location = this and 
          result = keySize.toString() }
      }
}
