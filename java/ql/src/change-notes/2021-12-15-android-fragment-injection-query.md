---
category: newQuery
---
* Two new queries, "Android fragment injection" (`java/android/fragment-injection`) and "Android fragment injection in PreferenceActivity" (`java/android/fragment-injection-preference-activity`) have been added.
These queries find exported Android activities that instantiate and host fragments created from user-provided data. Such activities are vulnerable to access control bypass and expose the Android application to unintended effects.