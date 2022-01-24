import cpp

/**
 * Align the specified offset up to the specified alignment boundary.
 * The result is the smallest integer `i` such that `(i % alignment) = 0`
 * and `(i >= offset)`.
 */
bindingset[offset, alignment]
private int alignUp(int offset, int alignment) {
  result = (offset.(float) / alignment).ceil() * alignment
}

private Type stripSpecifiers(Type t) {
  result = t.getUnspecifiedType()
  or
  result = t and not exists(t.getUnspecifiedType())
}

/**
 * A string that represents an architecture.
 * An "architecture" defines the sizes of variable-sized types and
 * the properties of alignment for fields of various
 * types. Two are provided out-of-the-box: ILP32 and LP64,
 * corresponding to gcc's behavior on x86 and amd64.
 */
abstract class Architecture extends string {
  bindingset[this]
  Architecture() { any() }

  /** Gets the size of a pointer, in bits. */
  abstract int pointerSize();

  /** Gets the size of a `long int`, in bits. */
  abstract int longSize();

  /** Gets the size of a `long double`, in bits. */
  abstract int longDoubleSize();

  /** Gets the size of a `long long`, in bits. */
  abstract int longLongSize();

  /** Gets the size of a `wchar_t`, in bits. */
  abstract int wideCharSize();

  /** Gets the alignment boundary for doubles, in bits. */
  abstract int doubleAlign();

  /** Gets the alignment boundary for long doubles, in bits. */
  abstract int longDoubleAlign();

  /** Gets the alignment boundary for long longs, in bits. */
  abstract int longLongAlign();

  /**
   * Holds if this architecture allow bitfields with declared types of different sizes
   * to be packed together.
   */
  abstract predicate allowHeterogeneousBitfields();

  /**
   * Gets the bit size of class `cd.getBaseClass()` when used as a base class of
   * class `cd.getDerivedClass()`.
   */
  abstract int baseClassSize(ClassDerivation cd);

  /**
   * Gets the bit size of type `t`. Only holds if `t` is an integral or enum type.
   */
  cached
  int integralBitSize(Type t) {
    t instanceof BoolType and result = 8
    or
    t instanceof CharType and result = 8
    or
    t instanceof WideCharType and result = this.wideCharSize()
    or
    t instanceof Char8Type and result = 8
    or
    t instanceof Char16Type and result = 16
    or
    t instanceof Char32Type and result = 32
    or
    t instanceof ShortType and result = 16
    or
    t instanceof IntType and result = 32
    or
    t instanceof LongType and result = this.longSize()
    or
    t instanceof LongLongType and result = this.longLongSize()
    or
    result = this.enumBitSize(t)
    or
    result = this.integralBitSize(t.(SpecifiedType).getBaseType())
    or
    result = this.integralBitSize(t.(TypedefType).getBaseType())
  }

  /**
   * Gets the bit size of enum type `e`.
   */
  int enumBitSize(Enum e) {
    result = this.integralBitSize(e.getExplicitUnderlyingType())
    or
    not exists(e.getExplicitUnderlyingType()) and result = 32
  }

  /**
   * Gets the alignment of enum type `e`.
   */
  int enumAlignment(Enum e) {
    result = this.alignment(e.getExplicitUnderlyingType())
    or
    not exists(e.getExplicitUnderlyingType()) and result = 32
  }

  /**
   * Gets the bit size of type `t`; that is, the number of bits a value
   * with type `t` takes up on this architecture, without any trailing
   * padding on structs and unions.
   */
  cached
  int bitSize(Type t) {
    result = this.integralBitSize(t)
    or
    t instanceof FloatType and result = 32
    or
    t instanceof DoubleType and result = 64
    or
    t instanceof LongDoubleType and result = this.longDoubleSize()
    or
    t instanceof PointerType and result = this.pointerSize()
    or
    t instanceof ReferenceType and result = this.pointerSize()
    or
    t instanceof FunctionPointerType and result = this.pointerSize()
    or
    result = this.bitSize(t.(SpecifiedType).getBaseType())
    or
    result = this.bitSize(t.(TypedefType).getBaseType())
    or
    exists(ArrayType array | array = t |
      result = array.getArraySize() * this.paddedSize(array.getBaseType())
    )
    or
    result = t.(PaddedType).typeBitSize(this)
  }

  /**
   * Gets the desired alignment boundary of type `t` as a struct field
   * on this architecture, in bits.
   */
  cached
  int alignment(Type t) {
    t instanceof BoolType and result = 8
    or
    t instanceof CharType and result = 8
    or
    t instanceof WideCharType and result = this.wideCharSize()
    or
    t instanceof Char8Type and result = 8
    or
    t instanceof Char16Type and result = 16
    or
    t instanceof Char32Type and result = 32
    or
    t instanceof ShortType and result = 16
    or
    t instanceof IntType and result = 32
    or
    t instanceof FloatType and result = 32
    or
    t instanceof DoubleType and result = this.doubleAlign()
    or
    t instanceof LongType and result = this.longSize()
    or
    t instanceof LongDoubleType and result = this.longDoubleAlign()
    or
    t instanceof LongLongType and result = this.longLongAlign()
    or
    t instanceof PointerType and result = this.pointerSize()
    or
    t instanceof FunctionPointerType and result = this.pointerSize()
    or
    t instanceof ReferenceType and result = this.pointerSize()
    or
    result = this.enumAlignment(t)
    or
    result = this.alignment(t.(SpecifiedType).getBaseType())
    or
    result = this.alignment(t.(TypedefType).getBaseType())
    or
    result = this.alignment(t.(ArrayType).getBaseType())
    or
    result = t.(PaddedType).typeAlignment(this)
  }

  /**
   * Gets the padded size of type `t` on this architecture; that is,
   * the number of bits that 'sizeof' should return, taking into account
   * any trailing padding on top of the bit size.
   */
  int paddedSize(Type t) {
    exists(Type realType | realType = stripSpecifiers(t) |
      if realType instanceof PaddedType
      then result = realType.(PaddedType).paddedSize(this)
      else result = this.bitSize(realType)
    )
  }

  /**
   * Gets the wasted space of type `t`; that is, the number of bits
   * spent on padding. This is zero for primitive types, and depends on
   * struct fields and their alignment otherwise. Trailing padding is
   * counted.
   */
  int wastedSpace(Type t) {
    if t instanceof PaddedType then result = t.(PaddedType).wastedSpace(this) else result = 0
  }
}

/**
 * Gets an initial field of type `t`. If `t` is not a union, an initial field is
 * either the first field declared in type `t`, or an initial field of the type
 * of the first field declared in `t`. If `t` is a union, an initial field is
 * either any field declared in type `t`, or an initial field of the type of any
 * field declared in `t`.
 */
private Field getAnInitialField(PaddedType t) {
  if t instanceof Union
  then
    // Any field of the union is an initial field
    result = t.getAField()
    or
    // Initial field of the type of a field of the union
    result = getAnInitialField(t.getAField().getUnspecifiedType())
  else
    exists(Field firstField | t.fieldIndex(firstField) = 1 |
      // The first field of `t`
      result = firstField
      or
      // Initial field of the first field of `t`
      result = getAnInitialField(firstField.getUnspecifiedType())
    )
}

/**
 * Base class for architectures that follow the Itanium ABI. This includes
 * pretty much everything except Windows, so we'll refer to this as
 * "UnixArchitecture" to avoid any confusion due to the use of the name
 * "Itanium".
 */
abstract class UnixArchitecture extends Architecture {
  bindingset[this]
  UnixArchitecture() { any() }

  override int baseClassSize(ClassDerivation cd) {
    if
      not exists(cd.getBaseClass().getABaseClass*().getAField()) and
      not exists(PaddedType fieldType |
        fieldType = getAnInitialField(cd.getDerivedClass()).getUnspecifiedType() and
        (
          // Check if the type of the field is a base type of the class, or
          // vice versa. This is an approximation of the actual rule, which is
          // that the field type and the class must not share a common
          // ancestor. This approximation should be sufficient for the vast
          // majority of cases.
          fieldType.getABaseClass*() = cd.getBaseClass() or
          fieldType = cd.getBaseClass().getABaseClass*()
        )
      )
    then
      // No fields in this class or any base classes.
      result = 0
    else result = cd.getBaseClass().(PaddedType).paddedSize(this)
  }

  override int longLongSize() { result = 64 }

  override int wideCharSize() { result = 32 }

  override predicate allowHeterogeneousBitfields() { any() }
}

/**
 * The ILP32 architecture has ints, longs and pointers
 * of 32 bits.
 */
class ILP32 extends UnixArchitecture {
  ILP32() { this = "ILP32" }

  override int pointerSize() { result = 32 }

  override int longSize() { result = 32 }

  override int longDoubleSize() { result = 96 }

  override int doubleAlign() { result = 32 }

  override int longLongAlign() { result = 32 }

  override int longDoubleAlign() { result = 32 }
}

/**
 * The LP64 architecture has longs and pointers of 64 bits.
 */
class LP64 extends UnixArchitecture {
  LP64() { this = "LP64" }

  override int pointerSize() { result = 64 }

  override int longSize() { result = 64 }

  override int longDoubleSize() { result = 128 }

  override int doubleAlign() { result = 64 }

  override int longLongAlign() { result = 64 }

  override int longDoubleAlign() { result = 128 }
}

/**
 * Base class for Windows architectures.
 */
abstract class WindowsArchitecture extends Architecture {
  bindingset[this]
  WindowsArchitecture() { any() }

  override int baseClassSize(ClassDerivation cd) {
    if not exists(cd.getBaseClass().getABaseClass*().getAField())
    then
      // No fields in this class or any base classes.
      result = 0
    else result = cd.getBaseClass().(PaddedType).paddedSize(this)
  }

  override int longSize() { result = 32 }

  override int longDoubleSize() { result = 64 }

  override int longLongSize() { result = 64 }

  override int wideCharSize() { result = 16 }

  override int doubleAlign() { result = 64 }

  override int longLongAlign() { result = 64 }

  override int longDoubleAlign() { result = 64 }

  override predicate allowHeterogeneousBitfields() { none() }
}

/**
 * The ILP32_MS architecture is essentially the same as the
 * ILP32 architecture, except that long doubles are 64 bits.
 */
class ILP32_MS extends WindowsArchitecture {
  ILP32_MS() { this = "ILP32_MS" }

  override int pointerSize() { result = 32 }
}

/**
 * The LLP64_MS architecture has pointers of 64 bits, but both
 * long and int are still 32 bits.
 */
class LLP64_MS extends WindowsArchitecture {
  LLP64_MS() { this = "LLP64_MS" }

  override int pointerSize() { result = 64 }
}

/**
 * A class that is subject to padding by the compiler, and hence can
 * introduce waste. Does not include types with virtual member functions,
 * virtual base classes, or multiple base classes. These are excluded due
 * to the complexity of the implementation.
 */
class PaddedType extends Class {
  PaddedType() {
    // We can't talk about bit size of template types.
    not this instanceof TemplateClass and
    // If the class has any virtual functions, the layout will be more
    // complicated due to the presence of a virtual function table pointer.
    not exists(MemberFunction f | f = this.getAMemberFunction() and f.isVirtual()) and
    not exists(ClassDerivation cd | cd = this.getADerivation() |
      // If the class has any virtual functions, the layout will be more
      // complicated due to the presence of a virtual base table pointer.
      cd.hasSpecifier("virtual")
      or
      // If one of the base classes was not a PaddedType, then we should not
      // attempt to lay out the derived class, either.
      not cd.getBaseClass() instanceof PaddedType
    ) and
    // Support only single inheritance for now. If multiple inheritance is
    // supported, be sure to fix up the calls to getABaseClass*() to correctly
    // handle the presence of multiple base class subojects with the same type.
    not exists(this.getDerivation(1))
  }

  /**
   * Holds if, for each architecture, a single padded size is
   * calculated for this type.
   * This is normally the case, but sometimes the same type can be
   * defined in different compilations with different sizes, normally
   * due to use of the preprocessor in its definition.
   */
  predicate isPrecise() { forex(Architecture arch | 1 = strictcount(arch.paddedSize(this))) }

  /**
   * Gets the padded size of this type on architecture `arch`, in bits.
   * This is its `bitSize`, rounded up to the next multiple of its
   * `alignment`.
   */
  int paddedSize(Architecture arch) {
    // Struct padding is weird: It needs to be such that struct arrays
    // can be allocated contiguously. That means that the trailing padding
    // has to bring the alignment up to the smallest common multiple of
    // the alignment values of all fields. In practice, since valid
    // alignment values are 1, 2, 4, 8 and 16, this means "the largest
    // alignment value".
    // If the class is empty, the size is rounded up to one byte.
    result = alignUp(arch.bitSize(this), arch.alignment(this)).maximum(8)
  }

  /**
   * Gets the number of bits wasted by padding at the end of this
   * struct.
   */
  int trailingPadding(Architecture arch) { result = this.paddedSize(arch) - arch.bitSize(this) }

  /**
   * Gets the number of bits wasted in this struct definition; that is.
   * the waste between fields plus any waste from trailing padding.
   * Only the space wasted directly in this type is counted, not space
   * wasted in nested structs. Note that for unions, the wasted space
   * is simply the amount of trailing padding, as other fields are not
   * laid out one after another, and hence there is no padding between
   * them.
   */
  int wastedSpace(Architecture arch) { result = arch.paddedSize(this) - this.dataSize(arch) }

  /**
   * Gets the total size of all fields declared in this class, not including any
   * padding between fields.
   */
  private int fieldDataSize(Architecture arch) {
    if this instanceof Union
    then result = max(Field f | f = this.getAMember() | this.fieldSize(f, arch))
    else result = sum(Field f | f = this.getAMember() | this.fieldSize(f, arch))
  }

  /**
   * Gets the data size of this type on architecture `arch`; that is,
   * the number of bits taken up by data, rather than any kind of
   * padding. Padding of fields that have struct type is
   * considered "data" for the purposes of this definition, since
   * removing it requires reorganizing other parts of the code.
   */
  int dataSize(Architecture arch) {
    result = sum(PaddedType c | c = this.getABaseClass*() | c.fieldDataSize(arch))
  }

  /**
   * Gets the optimal size of this type on architecture `arch`, that is,
   * the sum of the sizes of all fields, ignoring padding
   * between them, but adding any trailing padding required to align
   * the type properly. This is a lower bound on the actual size that
   * can be achieved just by reordering fields, and without
   * reorganizing member structs' field layouts.
   */
  int optimalSize(Architecture arch) {
    result = alignUp(this.dataSize(arch), arch.alignment(this)).maximum(8)
  }

  /**
   * Gets the bit size of this type on architecture `arch`, that is, the
   * size its fields and required padding take up, without including
   * any trailing padding that is necessary.
   */
  int typeBitSize(Architecture arch) {
    if this instanceof Union
    then
      // A correct implementation for unions would be:
      // ```
      //     result = max(fieldSize(_, arch))
      // ```
      // but that uses a recursive aggregate, which isn't supported in
      // QL. We therefore use this slightly more complex implementation
      // instead.
      result = this.biggestFieldSizeUpTo(this.lastFieldIndex(), arch)
    else
      // If we're not a union type, the size is the padded
      // sum of field sizes, padded.
      result = this.fieldEnd(this.lastFieldIndex(), arch)
  }

  /**
   * Gets the alignment, in bits, of the entire struct/union type for
   * architecture `arch`.
   */
  language[monotonicAggregates]
  int typeAlignment(Architecture arch) {
    // The alignment of the type is the largest alignment of any of its fields,
    // including fields from base class subobjects.
    result =
      max(PaddedType c |
        c = this.getABaseClass*()
      |
        c.biggestAlignmentUpTo(c.lastFieldIndex(), arch)
      )
  }

  /**
   * Gets the largest size, in bits, of the size of a field with
   * (1-based) index less than or equal to `index` on architecture
   * `arch`.
   */
  int biggestFieldSizeUpTo(int index, Architecture arch) {
    if index = 0
    then result = 0
    else
      exists(Field f, int fSize | index = this.fieldIndex(f) and fSize = this.fieldSize(f, arch) |
        result = fSize.maximum(this.biggestFieldSizeUpTo(index - 1, arch))
      )
  }

  /**
   * Gets the largest alignment boundary, in bits, required by a field
   * with (1-based) index less than or equal to `index` on architecture
   * `arch`.
   */
  int biggestAlignmentUpTo(int index, Architecture arch) {
    if index = 0
    then result = 1 // Minimum possible alignment
    else
      exists(Field f, int fAlign |
        index = this.fieldIndex(f) and fAlign = arch.alignment(f.getType())
      |
        result = fAlign.maximum(this.biggestAlignmentUpTo(index - 1, arch))
      )
  }

  /**
   * Gets the 1-based index for each field.
   */
  int fieldIndex(Field f) {
    this.memberIndex(f) =
      rank[result](Field field, int index | this.memberIndex(field) = index | index)
  }

  private int memberIndex(Field f) { result = min(int i | this.getCanonicalMember(i) = f) }

  /**
   * Gets the 1-based index for the last field.
   */
  int lastFieldIndex() {
    if exists(this.lastField())
    then result = this.fieldIndex(this.lastField())
    else
      // Field indices are 1-based, so return 0 to represent the lack of fields.
      result = 0
  }

  /**
   * Gets the size, in bits, of field `f` on architecture
   * `arch`.
   */
  int fieldSize(Field f, Architecture arch) {
    exists(this.fieldIndex(f)) and
    if f instanceof BitField
    then result = f.(BitField).getNumBits()
    else result = arch.paddedSize(f.getType())
  }

  /** Gets the last field of this type. */
  Field lastField() { this.fieldIndex(result) = max(Field other | | this.fieldIndex(other)) }

  /**
   * Gets the offset, in bits, of the end of the class' last base class
   * subobject, or zero if the class has no base classes.
   */
  int baseClassEnd(Architecture arch) {
    if exists(this.getABaseClass())
    then result = arch.baseClassSize(this.getADerivation())
    else result = 0
  }

  /** Gets the bitfield at field index `index`, if that field is a bitfield. */
  private BitField bitFieldAt(int index) { this.fieldIndex(result) = index }

  /**
   * Gets the 0-based offset, in bits, of the first free bit after
   * field `f` (which is the `index`th field of
   * this type), taking padding into account, on architecture `arch`.
   */
  int fieldEnd(int index, Architecture arch) {
    if index = 0
    then
      // Base case: No fields seen yet, so return the offset of the end of the
      // base class subojects.
      result = this.baseClassEnd(arch)
    else
      exists(Field f | index = this.fieldIndex(f) |
        exists(int fSize | fSize = this.fieldSize(f, arch) |
          // Recursive case: Take previous field's end point, pad and add
          // this field's size
          exists(int firstFree | firstFree = this.fieldEnd(index - 1, arch) |
            if f instanceof BitField
            then
              // Bitfield packing:
              // (1) A struct containing a bitfield with declared type T (e.g. T bf : 7) will be aligned as if it
              //     contained an actual field of type T. Thus, a struct containing a bitfield 'unsigned int bf : 8'
              //     will have an alignment of at least alignof(unsigned int), even though the bitfield was only 8 bits.
              // (2) If a bitfield with declared type T would straddle a sizeof(T) boundary, padding is inserted
              //     before the bitfield to align it on an alignof(T) boundary. Note the subtle distinction between alignof
              //     and sizeof. This matters for 32-bit Linux, where sizeof(long long) == 8, but alignof(long long) == 4.
              // (3) [MSVC only!] If a bitfield with declared type T immediately follows another bitfield with declared type P,
              //     and sizeof(P) != sizeof(T), padding will be inserted to align the new bitfield to a boundary of
              //     max(alignof(P), alignof(T)).
              exists(int nextSizeofBoundary, int nextAlignofBoundary |
                nextSizeofBoundary = alignUp(firstFree, arch.bitSize(f.getType())) and
                nextAlignofBoundary = alignUp(firstFree, arch.alignment(f.getType()))
              |
                if arch.allowHeterogeneousBitfields()
                then (
                  if nextSizeofBoundary < (firstFree + fSize)
                  then
                    // Straddles a sizeof(T) boundary, so pad for alignment.
                    result = nextAlignofBoundary + fSize
                  else
                    // No additional restrictions, so just pack it in with no padding.
                    result = firstFree + fSize
                ) else (
                  if exists(this.bitFieldAt(index - 1))
                  then
                    exists(BitField previousBitField |
                      previousBitField = this.bitFieldAt(index - 1)
                    |
                      // Previous field was a bitfield.
                      if
                        nextSizeofBoundary >= (firstFree + fSize) and
                        arch.integralBitSize(previousBitField.getType()) =
                          arch.integralBitSize(f.getType())
                      then
                        // The new bitfield can be stored in the same allocation unit as the previous one,
                        // so we can avoid padding.
                        result = firstFree + fSize
                      else
                        // Either we switched types, or we would overlap a sizeof(T) boundary, so we have to insert padding.
                        // Note that we have to align to max(alignof(T), alignof(P)), where P is the type of the previous
                        // bitfield. Without the alignof(P) term, we'll get the wrong layout for:
                        //   struct S {
                        //     unsigned int x : 7;
                        //     unsigned short y : 1;
                        //   };
                        // If we only aligned to sizeof(T), we'd align 'y' to a 2-byte boundary. This is incorrect. The allocation
                        // unit that started with 'x' has to consume an entire unsigned int (4 bytes).
                        result =
                          max(int boundary |
                              boundary = nextAlignofBoundary or
                              boundary =
                                alignUp(firstFree, arch.alignment(previousBitField.getType()))
                            |
                              boundary
                            ) + fSize
                    )
                  else
                    // Previous field was not a bitfield. Align up to an
                    // alignof(T) boundary.
                    result = nextSizeofBoundary + fSize
                )
              )
            else
              // Normal case: Pad as necessary, then add the field.
              result = alignUp(firstFree, arch.alignment(f.getType())) + fSize
          )
        )
      )
  }
}
