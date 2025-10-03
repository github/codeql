import java
import experimental.quantum.Language

from Crypto::NodeBase n, string key, string value, Location location
where n.properties(key, value, location)
select n, key, value, location
