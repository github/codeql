//wrong: inconsistent initialization, only the first should be initialized, 
//or all should be initialized
enum {
	VALUE_SHOULD_BE_10 = 10,
	VALUE_SHOULD_BE_11,
	VALUE_SHOULD_BE_12,
	VALUE_SHOULD_BE_20, //newly added member, but initialization was forgotten 
	                    //(would have a value of 13 instead of 20).
	VALUE_SHOULD_BE_30 = 30,
	VALUE_SHOULD_BE_40 = 40
} bad_values;

//correct: all enum values initialized
enum {
	VALUE_SHOULD_BE_10 = 10,
	VALUE_SHOULD_BE_11 = 11,
	VALUE_SHOULD_BE_12 = 12,
	VALUE_SHOULD_BE_20 = 20, //newly added member, it is less likely to forget
	                         //putting in initialization since everything else 
	                         //is initialized
	VALUE_SHOULD_BE_30 = 30,
	VALUE_SHOULD_BE_40 = 40
} good_values;
