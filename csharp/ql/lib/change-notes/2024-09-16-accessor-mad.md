---
category: breaking
---
* C#: Add support for MaD directly on properties and indexers using *attributes*. Using `Attribute.Getter` or `Attribute.Setter` in the model `ext` field applies the model to the getter or setter for properties and indexers. Prior to this change `Attribute` models unintentionally worked for property setters (if the property is decorated with the matching attribute). That is, a model that uses the `Attribute` feature directly on a property for a property setter needs to be changed to `Attribute.Setter`.
