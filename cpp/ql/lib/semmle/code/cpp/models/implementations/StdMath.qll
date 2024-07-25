/**
 * Provides models for C++ functions from the `cmath` header.
 */

private import semmle.code.cpp.models.interfaces.SideEffect
private import semmle.code.cpp.models.interfaces.Alias

private class LdExp extends Function, SideEffectFunction {
  LdExp() { this.hasGlobalOrStdOrBslName(["ldexp", "ldexpf", "ldexpl"]) }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }
}

private class Abs extends Function, SideEffectFunction {
  Abs() { this.hasGlobalOrStdOrBslName(["abs", "fabs", "fabsf", "fabsl", "llabs", "imaxabs"]) }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }
}

private class Div extends Function, SideEffectFunction {
  Div() { this.hasGlobalOrStdOrBslName(["div", "ldiv", "lldiv", "imaxdiv"]) }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }
}

private class FMod extends Function, SideEffectFunction {
  FMod() { this.hasGlobalOrStdOrBslName(["fmod", "fmodf", "fmodl"]) }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }
}

private class Remainder extends Function, SideEffectFunction {
  Remainder() { this.hasGlobalOrStdOrBslName(["remainder", "remainderf", "remainderl"]) }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }
}

private class Remquo extends Function, SideEffectFunction {
  Remquo() { this.hasGlobalOrStdOrBslName(["remquo", "remquof", "remquol"]) }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    this.getParameter(i).getUnspecifiedType() instanceof PointerType and
    buffer = false and
    mustWrite = true
  }
}

private class Fma extends Function, SideEffectFunction {
  Fma() { this.hasGlobalOrStdOrBslName(["fma", "fmaf", "fmal"]) }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }
}

private class Fmax extends Function, SideEffectFunction {
  Fmax() { this.hasGlobalOrStdOrBslName(["fmax", "fmaxf", "fmaxl"]) }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }
}

private class Fmin extends Function, SideEffectFunction {
  Fmin() { this.hasGlobalOrStdOrBslName(["fmin", "fminf", "fminl"]) }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }
}

private class Fdim extends Function, SideEffectFunction {
  Fdim() { this.hasGlobalOrStdOrBslName(["fdim", "fdimf", "fdiml"]) }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }
}

private class Nan extends Function, SideEffectFunction, AliasFunction {
  Nan() { this.hasGlobalOrStdOrBslName(["nan", "nanf", "nanl"]) }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate parameterNeverEscapes(int index) { index = 0 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = 0 and buffer = true
  }
}
