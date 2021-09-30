/** Provides classes and predicates for working with implicit `PendingIntent`s. */

import java
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.frameworks.android.Intent

private class PendingIntentModels extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "android.app;PendingIntent;false;getActivity;;;Argument[2];pending-intent",
        "android.app;PendingIntent;false;getActivities;;;Argument[2];pending-intent",
        "android.app;PendingIntent;false;getBroadcast;;;Argument[2];pending-intent",
        "android.app;PendingIntent;false;getService;;;Argument[2];pending-intent"
      ]
  }
}

// TODO: Remove when https://github.com/github/codeql/pull/6397 gets merged
private class DefaultIntentRedirectionSinkModel extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "android.app;Activity;true;startActivityAsCaller;;;Argument[0];intent-start",
        "android.app;Activity;true;startActivityForResult;(Intent,int);;Argument[0];intent-start",
        "android.app;Activity;true;startActivityForResult;(Intent,int,Bundle);;Argument[0];intent-start",
        "android.app;Activity;true;startActivityForResult;(String,Intent,int,Bundle);;Argument[1];intent-start",
        "android.app;Activity;true;startActivityForResultAsUser;;;Argument[0];intent-start",
        "android.content;Context;true;startActivities;;;Argument[0];intent-start",
        "android.content;Context;true;startActivity;;;Argument[0];intent-start",
        "android.content;Context;true;startActivityAsUser;;;Argument[0];intent-start",
        "android.content;Context;true;startActivityFromChild;;;Argument[1];intent-start",
        "android.content;Context;true;startActivityFromFragment;;;Argument[1];intent-start",
        "android.content;Context;true;startActivityIfNeeded;;;Argument[0];intent-start",
        "android.content;Context;true;startService;;;Argument[0];intent-start",
        "android.content;Context;true;startServiceAsUser;;;Argument[0];intent-start",
        "android.content;Context;true;sendBroadcast;;;Argument[0];intent-start",
        "android.content;Context;true;sendBroadcastAsUser;;;Argument[0];intent-start",
        "android.content;Context;true;sendBroadcastWithMultiplePermissions;;;Argument[0];intent-start",
        "android.content;Context;true;sendStickyBroadcast;;;Argument[0];intent-start",
        "android.content;Context;true;sendStickyBroadcastAsUser;;;Argument[0];intent-start",
        "android.content;Context;true;sendStickyOrderedBroadcast;;;Argument[0];intent-start",
        "android.content;Context;true;sendStickyOrderedBroadcastAsUser;;;Argument[0];intent-start"
      ]
  }
}

// TODO: Remove when https://github.com/github/codeql/pull/6599 gets merged
private class IntentBundleFlowSteps extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //"namespace;type;subtypes;name;signature;ext;input;output;kind"
        "android.os;BaseBundle;true;get;(String);;MapValue of Argument[-1];ReturnValue;value",
        "android.os;BaseBundle;true;getString;(String);;MapValue of Argument[-1];ReturnValue;value",
        "android.os;BaseBundle;true;getString;(String,String);;MapValue of Argument[-1];ReturnValue;value",
        "android.os;BaseBundle;true;getString;(String,String);;Argument[1];ReturnValue;value",
        "android.os;BaseBundle;true;getStringArray;(String);;MapValue of Argument[-1];ReturnValue;value",
        "android.os;BaseBundle;true;keySet;();;MapKey of Argument[-1];Element of ReturnValue;value",
        "android.os;BaseBundle;true;putAll;(PersistableBundle);;MapKey of Argument[0];MapKey of Argument[-1];value",
        "android.os;BaseBundle;true;putAll;(PersistableBundle);;MapValue of Argument[0];MapValue of Argument[-1];value",
        "android.os;BaseBundle;true;putBoolean;;;Argument[0];MapKey of Argument[-1];value",
        "android.os;BaseBundle;true;putBooleanArray;;;Argument[0];MapKey of Argument[-1];value",
        "android.os;BaseBundle;true;putDouble;;;Argument[0];MapKey of Argument[-1];value",
        "android.os;BaseBundle;true;putDoubleArray;;;Argument[0];MapKey of Argument[-1];value",
        "android.os;BaseBundle;true;putInt;;;Argument[0];MapKey of Argument[-1];value",
        "android.os;BaseBundle;true;putIntArray;;;Argument[0];MapKey of Argument[-1];value",
        "android.os;BaseBundle;true;putLong;;;Argument[0];MapKey of Argument[-1];value",
        "android.os;BaseBundle;true;putLongArray;;;Argument[0];MapKey of Argument[-1];value",
        "android.os;BaseBundle;true;putString;;;Argument[0];MapKey of Argument[-1];value",
        "android.os;BaseBundle;true;putString;;;Argument[1];MapValue of Argument[-1];value",
        "android.os;BaseBundle;true;putStringArray;;;Argument[0];MapKey of Argument[-1];value",
        "android.os;BaseBundle;true;putStringArray;;;Argument[1];MapValue of Argument[-1];value",
        "android.os;Bundle;true;getBinder;(String);;MapValue of Argument[-1];ReturnValue;value",
        "android.os;Bundle;true;getBundle;(String);;MapValue of Argument[-1];ReturnValue;value",
        "android.os;Bundle;true;getByteArray;(String);;MapValue of Argument[-1];ReturnValue;value",
        "android.os;Bundle;true;getCharArray;(String);;MapValue of Argument[-1];ReturnValue;value",
        "android.os;Bundle;true;getCharSequence;(String);;MapValue of Argument[-1];ReturnValue;value",
        "android.os;Bundle;true;getCharSequence;(String,CharSequence);;MapValue of Argument[-1];ReturnValue;value",
        "android.os;Bundle;true;getCharSequence;(String,CharSequence);;Argument[1];ReturnValue;value",
        "android.os;Bundle;true;getCharSequenceArray;(String);;MapValue of Argument[-1];ReturnValue;value",
        "android.os;Bundle;true;getCharSequenceArrayList;(String);;MapValue of Argument[-1];ReturnValue;value",
        "android.os;Bundle;true;getParcelable;(String);;MapValue of Argument[-1];ReturnValue;value",
        "android.os;Bundle;true;getParcelableArray;(String);;MapValue of Argument[-1];ReturnValue;value",
        "android.os;Bundle;true;getParcelableArrayList;(String);;MapValue of Argument[-1];ReturnValue;value",
        "android.os;Bundle;true;getSerializable;(String);;MapValue of Argument[-1];ReturnValue;value",
        "android.os;Bundle;true;getSparseParcelableArray;(String);;MapValue of Argument[-1];ReturnValue;value",
        "android.os;Bundle;true;getStringArrayList;(String);;MapValue of Argument[-1];ReturnValue;value",
        "android.os;Bundle;true;putAll;(Bundle);;MapKey of Argument[0];MapKey of Argument[-1];value",
        "android.os;Bundle;true;putAll;(Bundle);;MapValue of Argument[0];MapValue of Argument[-1];value",
        "android.os;Bundle;true;putBinder;;;Argument[0];MapKey of Argument[-1];value",
        "android.os;Bundle;true;putBinder;;;Argument[1];MapValue of Argument[-1];value",
        "android.os;Bundle;true;putBundle;;;Argument[0];MapKey of Argument[-1];value",
        "android.os;Bundle;true;putBundle;;;Argument[1];MapValue of Argument[-1];value",
        "android.os;Bundle;true;putByte;;;Argument[0];MapKey of Argument[-1];value",
        "android.os;Bundle;true;putByteArray;;;Argument[0];MapKey of Argument[-1];value",
        "android.os;Bundle;true;putByteArray;;;Argument[1];MapValue of Argument[-1];value",
        "android.os;Bundle;true;putChar;;;Argument[0];MapKey of Argument[-1];value",
        "android.os;Bundle;true;putCharArray;;;Argument[0];MapKey of Argument[-1];value",
        "android.os;Bundle;true;putCharArray;;;Argument[1];MapValue of Argument[-1];value",
        "android.os;Bundle;true;putCharSequence;;;Argument[0];MapKey of Argument[-1];value",
        "android.os;Bundle;true;putCharSequence;;;Argument[1];MapValue of Argument[-1];value",
        "android.os;Bundle;true;putCharSequenceArray;;;Argument[0];MapKey of Argument[-1];value",
        "android.os;Bundle;true;putCharSequenceArray;;;Argument[1];MapValue of Argument[-1];value",
        "android.os;Bundle;true;putCharSequenceArrayList;;;Argument[0];MapKey of Argument[-1];value",
        "android.os;Bundle;true;putCharSequenceArrayList;;;Argument[1];MapValue of Argument[-1];value",
        "android.os;Bundle;true;putFloat;;;Argument[0];MapKey of Argument[-1];value",
        "android.os;Bundle;true;putFloatArray;;;Argument[0];MapKey of Argument[-1];value",
        "android.os;Bundle;true;putIntegerArrayList;;;Argument[0];MapKey of Argument[-1];value",
        "android.os;Bundle;true;putParcelable;;;Argument[0];MapKey of Argument[-1];value",
        "android.os;Bundle;true;putParcelable;;;Argument[1];MapValue of Argument[-1];value",
        "android.os;Bundle;true;putParcelableArray;;;Argument[0];MapKey of Argument[-1];value",
        "android.os;Bundle;true;putParcelableArray;;;Argument[1];MapValue of Argument[-1];value",
        "android.os;Bundle;true;putParcelableArrayList;;;Argument[0];MapKey of Argument[-1];value",
        "android.os;Bundle;true;putParcelableArrayList;;;Argument[1];MapValue of Argument[-1];value",
        "android.os;Bundle;true;putSerializable;;;Argument[0];MapKey of Argument[-1];value",
        "android.os;Bundle;true;putSerializable;;;Argument[1];MapValue of Argument[-1];value",
        "android.os;Bundle;true;putShort;;;Argument[0];MapKey of Argument[-1];value",
        "android.os;Bundle;true;putShortArray;;;Argument[0];MapKey of Argument[-1];value",
        "android.os;Bundle;true;putSize;;;Argument[0];MapKey of Argument[-1];value",
        "android.os;Bundle;true;putSizeF;;;Argument[0];MapKey of Argument[-1];value",
        "android.os;Bundle;true;putSparceParcelableArray;;;Argument[0];MapKey of Argument[-1];value",
        "android.os;Bundle;true;putSparseParcelableArray;;;Argument[1];MapValue of Argument[-1];value",
        "android.os;Bundle;true;putStringArrayList;;;Argument[0];MapKey of Argument[-1];value",
        "android.os;Bundle;true;putStringArrayList;;;Argument[1];MapValue of Argument[-1];value",
        "android.os;Bundle;true;readFromParcel;;;Argument[0];MapKey of Argument[-1];taint",
        "android.os;Bundle;true;readFromParcel;;;Argument[0];MapValue of Argument[-1];taint",
        "android.content;Intent;true;getExtras;();;SyntheticField[android.content.Intent.extras] of Argument[-1];ReturnValue;value",
        "android.content;Intent;true;getBundleExtra;(String);;MapValue of SyntheticField[android.content.Intent.extras] of Argument[-1];ReturnValue;value",
        "android.content;Intent;true;getByteArrayExtra;(String);;MapValue of SyntheticField[android.content.Intent.extras] of Argument[-1];ReturnValue;value",
        "android.content;Intent;true;getCharArrayExtra;(String);;MapValue of SyntheticField[android.content.Intent.extras] of Argument[-1];ReturnValue;value",
        "android.content;Intent;true;getCharSequenceArrayExtra;(String);;MapValue of SyntheticField[android.content.Intent.extras] of Argument[-1];ReturnValue;value",
        "android.content;Intent;true;getCharSequenceArrayListExtra;(String);;MapValue of SyntheticField[android.content.Intent.extras] of Argument[-1];ReturnValue;value",
        "android.content;Intent;true;getCharSequenceExtra;(String);;MapValue of SyntheticField[android.content.Intent.extras] of Argument[-1];ReturnValue;value",
        "android.content;Intent;true;getParcelableArrayExtra;(String);;MapValue of SyntheticField[android.content.Intent.extras] of Argument[-1];ReturnValue;value",
        "android.content;Intent;true;getParcelableArrayListExtra;(String);;MapValue of SyntheticField[android.content.Intent.extras] of Argument[-1];ReturnValue;value",
        "android.content;Intent;true;getParcelableExtra;(String);;MapValue of SyntheticField[android.content.Intent.extras] of Argument[-1];ReturnValue;value",
        "android.content;Intent;true;getSerializableExtra;(String);;MapValue of SyntheticField[android.content.Intent.extras] of Argument[-1];ReturnValue;value",
        "android.content;Intent;true;getStringArrayExtra;(String);;MapValue of SyntheticField[android.content.Intent.extras] of Argument[-1];ReturnValue;value",
        "android.content;Intent;true;getStringArrayListExtra;(String);;MapValue of SyntheticField[android.content.Intent.extras] of Argument[-1];ReturnValue;value",
        "android.content;Intent;true;getStringExtra;(String);;MapValue of SyntheticField[android.content.Intent.extras] of Argument[-1];ReturnValue;value",
        "android.content;Intent;true;putCharSequenceArrayListExtra;;;Argument[0];MapKey of SyntheticField[android.content.Intent.extras] of Argument[-1];value",
        "android.content;Intent;true;putCharSequenceArrayListExtra;;;Argument[1];MapValue of SyntheticField[android.content.Intent.extras] of Argument[-1];value",
        "android.content;Intent;true;putCharSequenceArrayListExtra;;;Argument[-1];ReturnValue;value",
        "android.content;Intent;true;putExtra;;;Argument[0];MapKey of SyntheticField[android.content.Intent.extras] of Argument[-1];value",
        "android.content;Intent;true;putExtra;;;Argument[1];MapValue of SyntheticField[android.content.Intent.extras] of Argument[-1];value",
        "android.content;Intent;true;putExtra;;;Argument[-1];ReturnValue;value",
        "android.content;Intent;true;putIntegerArrayListExtra;;;Argument[0];MapKey of SyntheticField[android.content.Intent.extras] of Argument[-1];value",
        "android.content;Intent;true;putIntegerArrayListExtra;;;Argument[-1];ReturnValue;value",
        "android.content;Intent;true;putParcelableArrayListExtra;;;Argument[0];MapKey of SyntheticField[android.content.Intent.extras] of Argument[-1];value",
        "android.content;Intent;true;putParcelableArrayListExtra;;;Argument[1];MapValue of SyntheticField[android.content.Intent.extras] of Argument[-1];value",
        "android.content;Intent;true;putParcelableArrayListExtra;;;Argument[-1];ReturnValue;value",
        "android.content;Intent;true;putStringArrayListExtra;;;Argument[0];MapKey of SyntheticField[android.content.Intent.extras] of Argument[-1];value",
        "android.content;Intent;true;putStringArrayListExtra;;;Argument[1];MapValue of SyntheticField[android.content.Intent.extras] of Argument[-1];value",
        "android.content;Intent;true;putStringArrayListExtra;;;Argument[-1];ReturnValue;value",
        "android.content;Intent;true;putExtras;(Bundle);;MapKey of Argument[0];MapKey of SyntheticField[android.content.Intent.extras] of Argument[-1];value",
        "android.content;Intent;true;putExtras;(Bundle);;MapValue of Argument[0];MapValue of SyntheticField[android.content.Intent.extras] of Argument[-1];value",
        "android.content;Intent;true;putExtras;(Bundle);;Argument[-1];ReturnValue;value",
        "android.content;Intent;true;putExtras;(Intent);;MapKey of SyntheticField[android.content.Intent.extras] of Argument[0];MapKey of SyntheticField[android.content.Intent.extras] of Argument[-1];value",
        "android.content;Intent;true;putExtras;(Intent);;MapValue of SyntheticField[android.content.Intent.extras] of Argument[0];MapValue of SyntheticField[android.content.Intent.extras] of Argument[-1];value",
        "android.content;Intent;true;putExtras;(Intent);;Argument[-1];ReturnValue;value",
        "android.content;Intent;true;replaceExtras;(Bundle);;MapKey of Argument[0];MapKey of SyntheticField[android.content.Intent.extras] of Argument[-1];value",
        "android.content;Intent;true;replaceExtras;(Bundle);;MapValue of Argument[0];MapValue of SyntheticField[android.content.Intent.extras] of Argument[-1];value",
        "android.content;Intent;true;replaceExtras;(Bundle);;Argument[-1];ReturnValue;value",
        "android.content;Intent;true;replaceExtras;(Intent);;MapKey of SyntheticField[android.content.Intent.extras] of Argument[0];MapKey of SyntheticField[android.content.Intent.extras] of Argument[-1];value",
        "android.content;Intent;true;replaceExtras;(Intent);;MapValue of SyntheticField[android.content.Intent.extras] of Argument[0];MapValue of SyntheticField[android.content.Intent.extras] of Argument[-1];value",
        "android.content;Intent;true;replaceExtras;(Intent);;Argument[-1];ReturnValue;value"
      ]
  }
}
