import cpp

/**
 * A function that is used as the entry point of a VxWorks task.
 */
class Task extends Function {
  Task() {
    exists(FunctionCall taskCreate |
      taskCreate.getTarget().getName() = ["taskCreate", "taskSpawn"] and
      this = taskCreate.getArgument(4).(AddressOfExpr).getAddressable()
    )
  }
}

/**
 * From the JPL standard: "A public function is a function that is used
 * by multiple tasks, such as a library function". We additionally say that
 * a function is not public if it's defined in the same file as a task.
 *
 * And alternative definition could be to say that all functions defined in
 * files that don't define tasks are public.
 */
class PublicFunction extends Function {
  PublicFunction() {
    not this.isStatic() and
    (
      strictcount(Task t | t.calls+(this)) > 1 or
      not exists(Task t | t.getFile() = this.getFile())
    )
  }
}
