class WrongPair<L, R> implements Serializable{
    private final L left;            // BAD
    private final R right;           // BAD: L and R are not guaranteed to be serializable

    public WrongPair(L left, R right){ ... }

    ...
}

class Pair<L extends Serializable, R extends Serializable> implements Serializable{
    private final L left;            // GOOD: L and R must implement Serializable
    private final R right;

    public Pair(L left, R right){ ... }

    ...
}

class WrongEvent implements Serializable{
    private Object eventData;        // BAD: Type is too general.

    public WrongEvent(Object eventData){ ... }
}

class Event implements Serializable{
    private Serializable eventData;  // GOOD: Force the user to supply only serializable data

    public Event(Serializable eventData){ ... }
}
