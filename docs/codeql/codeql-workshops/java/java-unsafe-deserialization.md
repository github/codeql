# CodeQL Java Workshop - Unsafe deserialization in Apache Struts

## Problem Statement
- This workshop is about finding unsafe deserialization issue in Apache Struts
- Serialization is the process of converting in memory objects to text or binary output formats usually for the purpose of sharing or saving program state
-The serialized data can then be loaded back into memory through the process of deserialization 
- This is a common functionality - languages such as java, python, ruby, csharp deserialisation provides the ability to not only restore the primitive types but also the complex types such as library and user defined classes 
- This produces great power and flexibility but also does introduce a significant attack vector if the deserialisation happens on untrusted user data without any restriction (sanitization) 
- Apache struts is a popular MVC framework for creating web applications in Java
- CVE-2017-9805 - GitHub security lab found an XML deserialization vulnerability in Apache struts
- It was severe enough to allow for remote code execution   
- Included as a part of the Apache struts framework is the ability to accept requests in multiple different formats or content types
- Apache struts provides a pluggable handler for doing this through the `ContentTypeHandler`
- This interface provides an interface to `toObject`
- It is possible to define a `ContentTypeHandler` for XML or json by implementing this interface and defining your own `toObject`method. 
- The first parameter of `toObject` takes data as the first argument in the form of a `Reader` and then creates an `Object` target and populates it
- So how it works under the hood is that it's deserialising the `Reader` object to populate the target `Object` 
- This shouldn't happen without any kind of validation then the untrusted user data can be deserialised in a fairly arbitary way. Hence this CVE
- This database has been built from the known version of Apache struts

## Section 1 - Finding XML deserialization 
- XStream is a framework used for serializing and deserializing Java objects to and from XML  used by Apache Struts
- By default the input is not validated in anyway
- XStream does come with validation methods but they are not on by default 
- So it is vulnerable to remote code execution 
- First step: identify calls to `fromXML`
- Question 5 - explain exists. Existential quantifier.  We don't really care for the `MethodAccess` we just want to get back the `arg` itself. From a set perspective we have can think of this as having a predicate that names a table of results, that represents the set of all expressions in the program that we think are directly deserialized from xml. Can also use `|`
- Ask for feedback on time, questions etc  before moving onto sink 

## Section 2 Sinks 
- `RefType` reference type the set of things such as classes in Java that are called to by reference 
- Question 1 - fill in characteristic predicate to define what makes that class unique
- Question 2 - We start of with the set of all methods and we want to refine it to only those methods that are called `toObject` and are on something that implements this `ContentTypeHandler` interface
- We want to make sure that  the `toObject` extends the ContentTypeHandler, via getDeclaringType
