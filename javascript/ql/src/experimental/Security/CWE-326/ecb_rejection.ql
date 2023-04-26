/**
 * @name ECBRejection
 * @description Locates calls to a weak block mode being used in a Cryptographic Operation.
 * @id js/ecb_rejection
 * @tags security
 *       external/cwe/cwe-326
 */

import javascript
import semmle.javascript.Concepts
import semmle.javascript.frameworks.CryptoLibraries

class WeakBlockMode extends BlockMode {
    WeakBlockMode() {
        exists(CryptographicOperation application |
            (
                application.getBlockMode().isWeak()
            ) and
            this = application.getBlockMode()
        )
    }
}

from BlockMode bm, WeakBlockMode wbm, CryptographicOperation op
where
  op.getBlockMode() = bm and
  bm = wbm
select "A weak block cipher mode like " + bm + " does not secure sensitive data.", "The data is encoded with the weak block cipher in op. Make sure it is not sensitive data.", op