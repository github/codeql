---
category: feature
---
* Added a new predicate, `hasAnIntentFilterElement`, in the `AndroidComponentXmlElement` class to detect if a component contains an intent filter element.
* Added a new predicate, `hasExportedAttribute`, in the `AndroidComponentXmlElement` class to detect if a component has an `android:exported` attribute.
* Added a new predicate, `isImplicitlyExported`, in the `AndroidComponentXmlElement` class to detect if a component is implicitly exported.
* Added a new predicate, `getACategoryElement`, in the `AndroidIntentFilterXmlElement` class to detect if an intent filter contains a category element.
* Added a new predicate, `hasLauncherCategoryElement`, in the `AndroidIntentFilterXmlElement` class to detect if an intent filter contains a launcher category element.
* Added a new class, `AndroidCategoryXmlElement`, to represent a category element in an Android manifest file.
* Added a new predicate, `getCategoryName`, in the `AndroidCategoryXmlElement` class to get the name of the category element.
