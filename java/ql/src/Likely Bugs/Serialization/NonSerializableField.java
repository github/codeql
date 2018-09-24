class DerivedFactors {             // Class that contains derived values computed from entries in a
    private Number efficiency;     // performance record
    private Number costPerItem;
    private Number profitPerItem;
    ...
}

class WrongPerformanceRecord implements Serializable {
    private String unitId;
    private Number dailyThroughput;
    private Number dailyCost;
    private DerivedFactors factors;  // BAD: 'DerivedFactors' is not serializable
                                     // but is in a serializable class. This
                                     // causes a 'java.io.NotSerializableException'
                                     // when 'WrongPerformanceRecord' is serialized.
    ...
}

class PerformanceRecord implements Serializable {
    private String unitId;
    private Number dailyThroughput;
    private Number dailyCost;
    transient private DerivedFactors factors;  // GOOD: 'DerivedFactors' is declared
                                               // 'transient' so it does not contribute to the
                                               // serializable state of 'PerformanceRecord'.
    ...
}
