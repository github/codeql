/** Kdoc with no owner */
package foo.bar

/**
 * A group of *members*.
 *
 * This class has no useful logic; it's just a documentation example.
 *
 * @property name the name of this group.
 * @constructor Creates an empty group.
 */
class Group(val name: String) {

    /**
     * Members of this group.
     */
    private val members = mutableListOf<Any>()

    /**
     * Adds a [member] to this group.
     * @return the new size of the group.
     */
    fun add(member: Int): Int {
        // A line comment
        return 42
    }

    /*
    A block comment
    */
}

enum class Severity(val sev: Int) {
    Low(1),
    /** Medium is in the middle */
    Medium(2),
    /** This is high */
    High(3)
}

fun fn1() {
    /**
     * A variable.
    */
    val a = 1
}

/**
 * A type alias comment
 */
typealias MyType = Group
