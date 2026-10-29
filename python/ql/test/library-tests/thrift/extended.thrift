

struct User {
  1: string name
}

exception Error {
  1: i32 what,
  2: string why
}

service Extended {

   User getUser(1:i32 id) throws (1:Error error)
   (doggy.window = "true", doggy.howmuch = 1000)

}

typedef i32 int;

typedef i64(foo.bar = "hello") shrubbery;

struct with_annotations {

    1: optional int i1;
    2: int (type.annotate = "foo") i2;
    3: shubbery nice (knights.who.say = "ni");

} ( struct.anno = "y" )

enum Animals {
    cat = 1,
    mouse = 2,
    dog
} ( enum.anno = "x" )

service with_throws {

   int32 foo(1:i32 id) throws (
        1:Error error
        3:string cause
   )

}

typedef list<shrubbery> border ( ni = "false" )

service TheShop {

    Animals getPet(
        1: required User owner
    ) throws (
        1: Error napping
        2: AnotherError pining
        3: ThirdKindOfError resting
        4: Error deaf
    )
} (
    service.annotation = "thing"
)
