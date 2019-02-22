/**
 * @name Class defines a field that uses an ICryptoTransform class in a way that would be unsafe for concurrent threads.
 * @description The class has a field that directly or indirectly make use of a static System.Security.Cryptography.ICryptoTransform object.
 *              Using this an instance of this class in concurrent threads is dangerous as it may not only result in an error, 
 *              but under some circumstances may also result in incorrect results.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cs/thread-unsafe-icryptotransform-field-in-class
 * @tags concurrency
 *       security
 *       external/cwe/cwe-362
 */

import csharp

class ICryptoTransform extends Class {
  ICryptoTransform() {
    this.getABaseType*().hasQualifiedName("System.Security.Cryptography", "ICryptoTransform")
  }
}

predicate usesICryptoTransformType( Type t ) {
  exists(  ICryptoTransform ict |
    ict = t
    or usesICryptoTransformType( t.getAChild() )
  )
}

predicate hasICryptoTransformMember( Class c) {
  exists( Field f |
    f = c.getAMember()
    and ( 
      exists( ICryptoTransform ict | ict = f.getType() )
      or hasICryptoTransformMember(f.getType())
      or usesICryptoTransformType(f.getType())
    )
  )
}

predicate hasICryptoTransformStaticMemberNested( Class c ) {
  exists( Field f |
    f = c.getAMember() |
    hasICryptoTransformStaticMemberNested( f.getType() )
    or (
      f.isStatic() and hasICryptoTransformMember(f.getType())
      and not exists( Attribute a
        | a = f.getAnAttribute() | 
        a.getType().getQualifiedName() = "System.ThreadStaticAttribute"
      )
    )
  )
}

predicate hasICryptoTransformStaticMember( Class c, string msg) {
  exists( Field f |
    f = c.getAMember*()
    and f.isStatic()
    and not exists( Attribute a
      | a = f.getAnAttribute() 
      and a.getType().getQualifiedName() = "System.ThreadStaticAttribute"
    )
    and (
      exists( ICryptoTransform ict | 
        ict = f.getType() 
        and msg = "Static field " + f + " of type " + f.getType() + ", implements 'System.Security.Cryptography.ICryptoTransform', but it does not have an attribute [ThreadStatic]. The usage of this class is unsafe for concurrent threads."
      )
      or 
      ( 
        not exists( ICryptoTransform ict | ict = f.getType() ) // Avoid dup messages
        and exists( Type t | t = f.getType() |  
          usesICryptoTransformType(t)
          and msg = "Static field " + f + " of type " + f.getType() + " makes usage of 'System.Security.Cryptography.ICryptoTransform', but it does not have an attribute [ThreadStatic]. The usage of this class is unsafe for concurrent threads."
        )
      )
    )
  )
  or ( hasICryptoTransformStaticMemberNested(c) 
    and msg = "Class" + c + " implementation depends on a static object of type 'System.Security.Cryptography.ICryptoTransform' in a way that is unsafe for concurrent threads."
  )
}

from Class c , string s
  where hasICryptoTransformStaticMember(c, s)
select c, s
