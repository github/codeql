// Generated automatically from reactor.core.publisher.GroupedFlux for testing purposes

package reactor.core.publisher;

import reactor.core.publisher.Flux;

abstract public class GroupedFlux<K, V> extends reactor.core.publisher.Flux<V>
{
    public GroupedFlux(){}
    public abstract K key();
}
