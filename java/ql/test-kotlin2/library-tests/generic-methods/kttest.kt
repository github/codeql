fun test() {

    val cwp = ClassWithoutParams()
    cwp.noTypeParams();
    cwp.hasTypeParams<ClassWithoutParams>(null)

    val specialised = ClassWithParams<String>()
    specialised.noTypeParams()
    specialised.instanceHasTypeParam<ClassWithoutParams>(null)
    specialised.instanceHasTypeParamUsesClassTypeParam<ClassWithoutParams>(null, null)

    val wildcard : ClassWithParams<out Any> = ClassWithParams<Any>()
    wildcard.noTypeParams()
    wildcard.instanceHasTypeParam<ClassWithoutParams>(null)
    wildcard.instanceHasTypeParamUsesClassTypeParam<ClassWithoutParams>(null, null)

}
