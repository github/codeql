class TestKt<T> {

  var field: T? = null
  @JvmField
  var rawField: T? = null
  fun method() = field

}

class FieldUsedKt {}
class RawFieldUsedKt {}
class MethodUsedKt {}
class ConstructorUsedKt {}
class NeitherUsedKt {} 

class UserKt {

  fun test(neitherUsed: TestKt<NeitherUsedKt>, methodUsed: TestKt<MethodUsedKt>, fieldUsed: TestKt<FieldUsedKt>, rawFieldUsed: TestKt<RawFieldUsedKt>) { 

    fieldUsed.field = null
    rawFieldUsed.rawField = null
    methodUsed.method()
    val constructorUsed = TestKt<ConstructorUsedKt>()

  }

}
