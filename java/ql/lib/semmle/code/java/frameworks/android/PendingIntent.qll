/** Provides classes and predicates related to the class `PendingIntent`. */

import java

/** The class `android.app.PendingIntent`. */
class PendingIntent extends Class {
  PendingIntent() { this.hasQualifiedName("android.app", "PendingIntent") }
}

/** A call to a method that creates a `PendingIntent`. */
class PendingIntentCreation extends MethodCall {
  PendingIntentCreation() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType() instanceof PendingIntent and
      m.hasName([
          "getActivity", "getActivityAsUser", "getActivities", "getActivitiesAsUser",
          "getBroadcast", "getBroadcastAsUser", "getService", "getForegroundService"
        ])
    )
  }

  /** The `Intent` argument of this call. */
  Argument getIntentArg() { result = this.getArgument(2) }

  /** The flags argument of this call. */
  Argument getFlagsArg() { result = this.getArgument(3) }
}

/** A field of the class `PendingIntent` representing a flag. */
class PendingIntentFlag extends Field {
  PendingIntentFlag() {
    this.getDeclaringType() instanceof PendingIntent and
    this.isPublic() and
    this.getName().matches("FLAG_%")
  }
}

/** The field `FLAG_IMMUTABLE` of the class `PendingIntent`. */
class ImmutablePendingIntentFlag extends PendingIntentFlag {
  ImmutablePendingIntentFlag() { this.hasName("FLAG_IMMUTABLE") }
}

/** The field `FLAG_MUTABLE` of the class `PendingIntent`. */
class MutablePendingIntentFlag extends PendingIntentFlag {
  MutablePendingIntentFlag() { this.hasName("FLAG_MUTABLE") }
}
