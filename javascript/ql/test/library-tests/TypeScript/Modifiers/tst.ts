abstract class ClassField {
  private private1: number;
  private readonly private2: number;
  private static private3: number;
  private static readonly private4: number;
  private ['cprivate1']: number;
  private readonly ['cprivate2']: number;
  private static ['cprivate3']: number;
  private static readonly ['cprivate4']: number;

  protected protected1: number;
  protected readonly protected2: number;
  protected static protected3: number;
  protected static readonly protected4: number;
  protected abstract protected5: number;
  protected abstract readonly protected6: number;
  protected ['cprotected1']: number;
  protected readonly ['cprotected2']: number;
  protected static ['cprotected3']: number;
  protected static readonly ['cprotected4']: number;
  protected abstract ['cprotected5']: number;
  protected abstract readonly ['cprotected6']: number;

  public public1: number;
  public readonly public2: number;
  public static public3: number;
  public static readonly public4: number;
  public abstract public5: number;
  public abstract readonly public6: number;
  public ['cpublic1']: number;
  public readonly ['cpublic2']: number;
  public static ['cpublic3']: number;
  public static readonly ['cpublic4']: number;
  public abstract ['cpublic5']: number;
  public abstract readonly ['cpublic6']: number;

  default1: number;
  readonly default2: number;
  static default3: number;
  static readonly default4: number;
  abstract deafult5: number;
  abstract readonly default6: number;
  ['cdefault1']: number;
  readonly ['cdefault2']: number;
  static ['cdefault3']: number;
  static readonly ['cdefault4']: number;
  abstract ['cdeafult5']: number;
  abstract readonly ['cdefault6']: number;
}

abstract class ClassMethods {
  private private1() {}
  private static private3() {}
  private ['cprivate1']() {}
  private static ['cprivate3']() {}

  protected protected1() {}
  protected static protected3() {}
  protected abstract protected5();
  protected ['cprotected1']() {}
  protected static ['cprotected3']() {}
  protected abstract ['cprotected5']();

  public public1() {}
  public static public3() {}
  public abstract public5();
  public ['cpublic1']() {}
  public static ['cpublic3']() {}
  public abstract ['cpublic5']();

  default1() {}
  static default3() {}
  abstract deafult5();
  ['cdefault1']() {}
  static ['cdefault3']() {}
  abstract ['cdeafult5']();
}

class ClassFieldParameters {
  constructor(
    private private1: number,
    private readonly private2: number,
    protected protected1: number,
    protected readonly protected2: number,
    public public1: number,
    public readonly public2: number,
    readonly default1: number,
    ordinaryParameter1: number,

    private private3: number = 0,
    private readonly private4: number = 0,
    protected protected3: number = 0,
    protected readonly protected4: number = 0,
    public public3: number = 0,
    public readonly public4: number = 0,
    readonly default3: number = 0,
    ordinaryParameter2: number = 0,
    
    private private5 = 0,
    private readonly private6 = 0,
    protected protected5 = 0,
    protected readonly protected6 = 0,
    public public5 = 0,
    public readonly public6 = 0,
    readonly default5 = 0,
    ordinaryParameter3 = 0,
  ) {}
}

interface InterfaceFields {
  x: number;
  readonly y: number;
  z?: number;
  readonly w?: number;
}
