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

pub struct Slice<T>;
pub struct Array<T, const N: usize>;
pub struct Ref<T>; // todo: add mut variant
pub struct Ptr<T>; // todo: add mut variant

// tuples
pub struct Tuple0;
pub struct Tuple1<T>(T);
pub struct Tuple2<T1, T2>(T1, T2);
pub struct Tuple3<T1, T2, T3>(T1, T2, T3);
pub struct Tuple4<T1, T2, T3, T4>(T1, T2, T3, T4);
pub struct Tuple5<T1, T2, T3, T4, T5>(T1, T2, T3, T4, T5);
pub struct Tuple6<T1, T2, T3, T4, T5, T6>(T1, T2, T3, T4, T5, T6);
pub struct Tuple7<T1, T2, T3, T4, T5, T6, T7>(T1, T2, T3, T4, T5, T6, T7);
pub struct Tuple8<T1, T2, T3, T4, T5, T6, T7, T8>(T1, T2, T3, T4, T5, T6, T7, T8);
pub struct Tuple9<T1, T2, T3, T4, T5, T6, T7, T8, T9>(T1, T2, T3, T4, T5, T6, T7, T8, T9);
pub struct Tuple10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>(
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
pub struct Tuple11<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>(
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
pub struct Tuple12<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>(
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
    T12,
);
pub struct Tuple13<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>(
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
    T12,
    T13,
);
pub struct Tuple14<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>(
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
    T12,
    T13,
    T14,
);
pub struct Tuple15<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15>(
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
    T12,
    T13,
    T14,
    T15,
);
pub struct Tuple16<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16>(
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
    T12,
    T13,
    T14,
    T15,
    T16,
);
