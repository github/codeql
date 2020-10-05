# Deserialization of user-controlled data

```
ID: java/unsafe-deserialization
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-502

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/java/ql/src/Security/CWE/CWE-502/UnsafeDeserialization.ql)

Deserializing untrusted data using any deserialization framework that allows the construction of arbitrary serializable objects is easily exploitable and in many cases allows an attacker to execute arbitrary code. Even before a deserialized object is returned to the caller of a deserialization method a lot of code may have been executed, including static initializers, constructors, and finalizers. Automatic deserialization of fields means that an attacker may craft a nested combination of objects on which the executed initialization code may have unforeseen effects, such as the execution of arbitrary code.

There are many different serialization frameworks. This query currently supports Kryo, XmlDecoder, XStream, SnakeYaml, and Java IO serialization through `ObjectInputStream`/`ObjectOutputStream`.


## Recommendation
Avoid deserialization of untrusted data if at all possible. If the architecture permits it then use other formats instead of serialized objects, for example JSON or XML. However, these formats should not be deserialized into complex objects because this provides further opportunities for attack. For example, XML-based deserialization attacks are possible through libraries such as XStream and XmlDecoder. Alternatively, a tightly controlled whitelist can limit the vulnerability of code, but be aware of the existence of so-called Bypass Gadgets, which can circumvent such protection measures.


## Example
The following example calls `readObject` directly on an `ObjectInputStream` that is constructed from untrusted data, and is therefore inherently unsafe.


```java
public MyObject {
  public int field;
  MyObject(int field) {
    this.field = field;
  }
}

public MyObject deserialize(Socket sock) {
  try(ObjectInputStream in = new ObjectInputStream(sock.getInputStream())) {
    return (MyObject)in.readObject(); // unsafe
  }
}

```
Rewriting the communication protocol to only rely on reading primitive types from the input stream removes the vulnerability.


```java
public MyObject deserialize(Socket sock) {
  try(DataInputStream in = new DataInputStream(sock.getInputStream())) {
    return new MyObject(in.readInt());
  }
}

```

## References
* OWASP vulnerability description: [Deserialization of untrusted data](https://www.owasp.org/index.php/Deserialization_of_untrusted_data).
* OWASP guidance on deserializing objects: [Deserialization Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Deserialization_Cheat_Sheet.html).
* Talks by Chris Frohoff & Gabriel Lawrence: [ AppSecCali 2015: Marshalling Pickles - how deserializing objects will ruin your day](http://frohoff.github.io/appseccali-marshalling-pickles/), [OWASP SD: Deserialize My Shorts: Or How I Learned to Start Worrying and Hate Java Object Deserialization](http://frohoff.github.io/owaspsd-deserialize-my-shorts/).
* Alvaro Muñoz & Christian Schneider, RSAConference 2016: [Serial Killer: Silently Pwning Your Java Endpoints](https://www.rsaconference.com/writable/presentations/file_upload/asd-f03-serial-killer-silently-pwning-your-java-endpoints.pdf).
* SnakeYaml documentation on deserialization: [SnakeYaml deserialization](https://bitbucket.org/asomov/snakeyaml/wiki/Documentation#markdown-header-loading-yaml).
* Common Weakness Enumeration: [CWE-502](https://cwe.mitre.org/data/definitions/502.html).