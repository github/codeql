cached
newtype TConstantValue =
  TInt(int i) { any(RequiredConstantValue x).requiredInt(i) } or
  TFloat(float f) { any(RequiredConstantValue x).requiredFloat(f) } or
  TRational(int numerator, int denominator) {
    any(RequiredConstantValue x).requiredRational(numerator, denominator)
  } or
  TComplex(float real, float imaginary) {
    any(RequiredConstantValue x).requiredComplex(real, imaginary)
  } or
  TString(string s) { any(RequiredConstantValue x).requiredString(s) } or
  TSymbol(string s) { any(RequiredConstantValue x).requiredSymbol(s) } or
  TBoolean(boolean b) { b in [false, true] } or
  TNil()

private newtype TRequiredConstantValue = MkRequiredConstantValue()

/**
 * A class that exists for QL technical reasons only (the IPA type used
 * to represent constant values needs to be bounded).
 */
class RequiredConstantValue extends MkRequiredConstantValue {
  string toString() { none() }

  predicate requiredInt(int i) { none() }

  predicate requiredFloat(float f) { none() }

  predicate requiredRational(int numerator, int denominator) { none() }

  predicate requiredComplex(float real, float imaginary) { none() }

  predicate requiredString(string s) { none() }

  predicate requiredSymbol(string s) { none() }
}
