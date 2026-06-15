public class ClassWithParams<T> {

  fun noTypeParams() { }

  fun <S> instanceHasTypeParam(s : S?) { }

  fun <S> instanceHasTypeParamUsesClassTypeParam(s : S?, t: T?) { }

}

