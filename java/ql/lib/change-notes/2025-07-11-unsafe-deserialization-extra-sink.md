---
category: minorAnalysis
---
* The qualifiers of a calls to `readObject` on any classes that implement `java.io.ObjectInput` are now recognised as sinks for `java/unsafe-deserialization`. Previously this was only the case for classes which extend `java.io.ObjectInputStream`.
