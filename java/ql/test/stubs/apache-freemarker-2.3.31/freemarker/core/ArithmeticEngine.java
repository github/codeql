// Generated automatically from freemarker.core.ArithmeticEngine for testing purposes

package freemarker.core;


abstract public class ArithmeticEngine
{
    protected int maxScale = 0;
    protected int minScale = 0;
    protected int roundingPolicy = 0;
    public ArithmeticEngine(){}
    public abstract Number add(Number p0, Number p1);
    public abstract Number divide(Number p0, Number p1);
    public abstract Number modulus(Number p0, Number p1);
    public abstract Number multiply(Number p0, Number p1);
    public abstract Number subtract(Number p0, Number p1);
    public abstract Number toNumber(String p0);
    public abstract int compareNumbers(Number p0, Number p1);
    public static ArithmeticEngine.BigDecimalEngine BIGDECIMAL_ENGINE = null;
    public static ArithmeticEngine.ConservativeEngine CONSERVATIVE_ENGINE = null;
    public void setMaxScale(int p0){}
    public void setMinScale(int p0){}
    public void setRoundingPolicy(int p0){}
    static public class BigDecimalEngine extends ArithmeticEngine
    {
        public BigDecimalEngine(){}
        public Number add(Number p0, Number p1){ return null; }
        public Number divide(Number p0, Number p1){ return null; }
        public Number modulus(Number p0, Number p1){ return null; }
        public Number multiply(Number p0, Number p1){ return null; }
        public Number subtract(Number p0, Number p1){ return null; }
        public Number toNumber(String p0){ return null; }
        public int compareNumbers(Number p0, Number p1){ return 0; }
    }
    static public class ConservativeEngine extends ArithmeticEngine
    {
        public ConservativeEngine(){}
        public Number add(Number p0, Number p1){ return null; }
        public Number divide(Number p0, Number p1){ return null; }
        public Number modulus(Number p0, Number p1){ return null; }
        public Number multiply(Number p0, Number p1){ return null; }
        public Number subtract(Number p0, Number p1){ return null; }
        public Number toNumber(String p0){ return null; }
        public int compareNumbers(Number p0, Number p1){ return 0; }
    }
}
