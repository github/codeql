---
category: minorAnalysis
---
* Added the `AndroidActivityAliasXmlElement` class to represent `<activity-alias>` components in Android manifests.
* Added the `AndroidActivityXmlElement.getAnAlias` method to get the aliases of an `<activity>` element in an Android manifest.
* Added the `AndroidIdentifierXmlAttribute` class to represent XML attributes representing component identifiers, such as `android:name` and `android:targetActivity`
* Added the `AndroidComponentXmlElement.getResolvedIdentifier` method, for finding the fully qualified identifier from an identifier.
* Added the `AndroidComponentXmlElement.getResolvedComponentName` method, for finding the fully qualified identifier of a component.
