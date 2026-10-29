# TODO: this should be a .rbi file if we decide to extract them by default

module TestTypes
  sig { void }
  def perform_some_action; end

  sig { returns(Integer) }
  def return_one; end

  sig { params(a: Integer, b: Integer).returns(Integer) }
  def add(a, b); end

  sig { params(a: Integer).returns(T::Boolean) }
  def isPositive(a); end

  class MyClass; end

  sig { returns(MyClass) }
  def getMyClassInstance(); end

  sig { returns(String) }
  attr_reader :name, :kind

  sig { returns(Integer) }
  attr_accessor :version

  sig do
    params(
      a: String,
      block: T.nilable(T.proc.params(b: Integer).void)
    ).void
  end
  def blk_nilable_method(a, &block); end

  sig do
    params(
      a: String,
      block: T.proc.params(b: Integer).returns(String)
    )
  end
  def blk_method(a, &block); end

  sig { params(hash: T::Hash[T.untyped, T.untyped]).void }
  def read_hash(**hash); end

  sig { params(arr: T::Array[Symbol]) }
  def read_symbol_array(*arr); end

  sig { params(new_name: T.any(String, Symbol)).returns(String) }
  def rename(new_name); end

  sig { params(value: T::Boolean).returns(T::Boolean) }
  def self.debug_mode=(value); end
end
