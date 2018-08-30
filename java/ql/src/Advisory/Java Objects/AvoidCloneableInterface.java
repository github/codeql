public final class Galaxy {

    // This is the original constructor.
    public Galaxy (double aMass, String aName) {
        fMass = aMass;
        fName = aName;
    }

    // This is the copy constructor.
    public Galaxy(Galaxy aGalaxy) {
        this(aGalaxy.getMass(), aGalaxy.getName());
    }

    // ...
}