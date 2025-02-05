/**
 * @name "PQC Test"
 */

 import experimental.Quantum.Language

from JCAModel::AESLiteral l 
select l, l.getAlg(), l.getMode().getValue(), l.getPadding().getValue()