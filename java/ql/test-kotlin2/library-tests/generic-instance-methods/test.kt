class Generic<T>(init: T) { 

  var stored = init

  fun identity2(param: T): T = identity(param)
  fun identity(param: T): T = param
  fun getter(): T = stored
  fun setter(param: T) { stored = param }

  private fun privateid(param: T) = param
  fun callPrivateId(gs: Generic<String>) = gs.privateid("hello world")

}

fun user() {

  val invariant = Generic<String>("hello world")
  invariant.identity("hello world")
  invariant.identity2("hello world")

  val projectedOut: Generic<out String> = invariant
  projectedOut.getter()

  val projectedIn: Generic<in String> = invariant
  projectedIn.setter("hi planet")
  projectedIn.getter()

}
