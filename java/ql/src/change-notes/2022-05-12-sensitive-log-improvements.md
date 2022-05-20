---
category: minorAnalysis
---
* Query `java/sensitive-log` has received several improvements.
  * It no longer considers usernames as sensitive information.
  * The conditions to consider a variable a constant (and therefore exclude it as user-provided sensitive information) have been tightened.
  * A sanitizer has been added to handle certain elements introduced by a Kotlin compiler plugin that have deceptive names.
