fun f(n: Number, b: Byte) = n.toByte() + n.toShort() + n.toInt() + n.toLong() + n.toFloat() + n.toDouble() + b.toByte() + b.toShort() + b.toInt() + b.toLong() + b.toFloat() + b.toDouble()

// Diagnostic Matches: % Couldn't find a Java equivalent function to kotlin.Byte.toByte in java.lang.Byte  ...while extracting a call (<no name>) at %test.kt:1:112:1:119%
// Diagnostic Matches: % Couldn't find a Java equivalent function to kotlin.Byte.toDouble in java.lang.Byte  ...while extracting a call (<no name>) at %test.kt:1:178:1:187%
// Diagnostic Matches: % Couldn't find a Java equivalent function to kotlin.Byte.toFloat in java.lang.Byte  ...while extracting a call (<no name>) at %test.kt:1:164:1:172%
// Diagnostic Matches: % Couldn't find a Java equivalent function to kotlin.Byte.toInt in java.lang.Byte  ...while extracting a call (<no name>) at %test.kt:1:139:1:145%
// Diagnostic Matches: % Couldn't find a Java equivalent function to kotlin.Byte.toLong in java.lang.Byte  ...while extracting a call (<no name>) at %test.kt:1:151:1:158%
// Diagnostic Matches: % Couldn't find a Java equivalent function to kotlin.Byte.toShort in java.lang.Byte  ...while extracting a call (<no name>) at %test.kt:1:125:1:133%
