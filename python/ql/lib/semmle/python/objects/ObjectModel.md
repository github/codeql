
# Object model for Python analysis

## General idea

Each 'object' in the analysis represents a static approximation to a set of objects in the actual program.
For objects like classes and functions there is a (mostly) one-to-one correspondence.
For instances, bound-methods and other short lived objects, one entity in the analysis represents a set of similar objects.

## APIs

Objects have two APIs; an internal and a user-facing API.

### Internal API

The internal API, exposed through `ObjectInternal` class, provides the predicates necessary for points-to to infer the behaviour of the object. This covers a number of operations:

    * Truth tests
    * Type tests and type(x) calls
    * Attribute access
    * Calls
    * Subscripting
    * Descriptors
    * Comparing objects
    * Treating the object as an integer or a string

Part of internal API exists to allow other objects to implement the points-to facing part of the API.
For example, behaviour of a (Python) class will determine the behaviour of instances of that class.

### User-facing API

The user-facing API, exposed through `Value` class, provides a higher level API designed for writing queries rather
than implementing points-to. It provides easy access to objects by name and the ability to find calls to, attributes of, and references to objects.


