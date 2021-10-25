import semmle.python.dataflow.new.DataFlow
import semmle.python.Concepts

from Cryptography::PublicKey::KeyGeneration keyGen, int keySize, DataFlow::Node origin
where
  keyGen.getLocation().getFile().getShortName() = "ec_keygen_origin.py" and
  keySize = keyGen.getKeySizeWithOrigin(origin)
select keyGen, keySize, origin
