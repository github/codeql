// The Language Prelude: https://doc.rust-lang.org/reference/names/preludes.html#language-prelude

// Type namespace
// Boolean type
pub struct bool;
// Textual types
pub struct char;
pub struct str;
// Integer types
pub struct i8;
pub struct i16;
pub struct i32;
pub struct i64;
pub struct i128;
pub struct u8;
pub struct u16;
pub struct u32;
pub struct u64;
pub struct u128;
// Machine-dependent integer types
pub struct usize;
pub struct isize;
// floating-point types
pub struct f32;
pub struct f64;

struct Slice<TSlice>;
struct Array<TArray, const N: usize>;
struct Ref<TRef>;
struct RefMut<TRefMut>;
struct PtrConst<TPtrConst>;
struct PtrMut<TPtrMut>;

// tuples
struct Tuple0;
struct Tuple1<T0>(T0);
struct Tuple2<T0, T1>(T0, T1);
struct Tuple3<T0, T1, T2>(T0, T1, T2);
struct Tuple4<T0, T1, T2, T3>(T0, T1, T2, T3);
struct Tuple5<T0, T1, T2, T3, T4>(T0, T1, T2, T3, T4);
struct Tuple6<T0, T1, T2, T3, T4, T5>(T0, T1, T2, T3, T4, T5);
struct Tuple7<T0, T1, T2, T3, T4, T5, T6>(T0, T1, T2, T3, T4, T5, T6);
struct Tuple8<T0, T1, T2, T3, T4, T5, T6, T7>(T0, T1, T2, T3, T4, T5, T6, T7);
struct Tuple9<T0, T1, T2, T3, T4, T5, T6, T7, T8>(T0, T1, T2, T3, T4, T5, T6, T7, T8);
struct Tuple10<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9>(T0, T1, T2, T3, T4, T5, T6, T7, T8, T9);
struct Tuple11<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>(
    T0,
    T1,
    T2,
    T3,
    T4,
    T5,
    T6,
    T7,
    T8,
    T9,
    T10,
);
struct Tuple12<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>(
    T0,
    T1,
    T2,
    T3,
    T4,
    T5,
    T6,
    T7,
    T8,
    T9,
    T10,
    T11,
);
