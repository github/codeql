package orm

//nolint
const (
	// Date / Time
	pgTypeTimestamp   = "timestamp"           // Timestamp without a time zone
	pgTypeTimestampTz = "timestamptz"         // Timestamp with a time zone
	pgTypeDate        = "date"                // Date
	pgTypeTime        = "time"                // Time without a time zone
	pgTypeTimeTz      = "time with time zone" // Time with a time zone
	pgTypeInterval    = "interval"            // Time Interval

	// Network Addresses
	pgTypeInet    = "inet"    // IPv4 or IPv6 hosts and networks
	pgTypeCidr    = "cidr"    // IPv4 or IPv6 networks
	pgTypeMacaddr = "macaddr" // MAC addresses

	// Boolean
	pgTypeBoolean = "boolean"

	// Numeric Types

	// Floating Point Types
	pgTypeReal            = "real"             // 4 byte floating point (6 digit precision)
	pgTypeDoublePrecision = "double precision" // 8 byte floating point (15 digit precision)

	// Integer Types
	pgTypeSmallint = "smallint" // 2 byte integer
	pgTypeInteger  = "integer"  // 4 byte integer
	pgTypeBigint   = "bigint"   // 8 byte integer

	// Serial Types
	pgTypeSmallserial = "smallserial" // 2 byte autoincrementing integer
	pgTypeSerial      = "serial"      // 4 byte autoincrementing integer
	pgTypeBigserial   = "bigserial"   // 8 byte autoincrementing integer

	// Character Types
	pgTypeVarchar = "varchar" // variable length string with limit
	pgTypeChar    = "char"    // fixed length string (blank padded)
	pgTypeText    = "text"    // variable length string without limit

	// JSON Types
	pgTypeJSON  = "json"  // text representation of json data
	pgTypeJSONB = "jsonb" // binary representation of json data

	// Binary Data Types
	pgTypeBytea = "bytea" // binary string
)
