---
category: feature
---
* Added a new predicate, `requiresPermissions`, in the `AndroidComponentXmlElement` and `AndroidApplicationXmlElement` classes to detect if the element has explicitly set a value for its `android:permission` attribute. Also added `override` annotation to the pre-existing `requiresPermissions` predicate in the `AndroidProviderXmlElement` class.
* Added a new predicate, `hasAnIntentFilterElement`, in the `AndroidComponentXmlElement` class to detect if a component contains an intent filter element.
* Added a new predicate, `hasExportedAttribute`, in the `AndroidComponentXmlElement` class to detect if a component has an `android:exported` attribute.
* Added a new class, `AndroidCategoryXmlElement`, to represent a category element in an Android manifest file. Also added a new predicate, `getCategoryName`, in this class to get the name of the category element.
* Added a new predicate, `getACategoryElement`, in the `AndroidIntentFilterXmlElement` class to get a category element of an intent filter.
