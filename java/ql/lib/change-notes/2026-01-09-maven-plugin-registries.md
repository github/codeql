---
category: minorAnalysis
---
* When Maven-compatible private package registries are configured for an organisation for Default Setup, CodeQL will now configure Maven to also use these as plugin repositories. CodeQL previously already configured Maven to use them as regular package repositories. This should now allow Maven plugins to be obtained from private registries.
