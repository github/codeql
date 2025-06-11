import cpp
import experimental.quantum.Language

from Crypto::KeyCreationOperationNode n, Crypto::NodeBase src
where n.getAKeySizeSource() = src
select n, src, src.asElement()
