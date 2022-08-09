func clean() throws -> String { return ""; }
func source() throws -> String { return ""; }
func sink(arg: String) {}

func taintThroughTry() {
	do
	{
		sink(arg: try clean())
		sink(arg: try source()) // tainted [NOT DETECTED]
	} catch {
		// ...
	}

	sink(arg: try! clean())
	sink(arg: try! source()) // tainted [NOT DETECTED]

	sink(arg: (try? clean())!)
	sink(arg: (try? source())!) // tainted [NOT DETECTED]
}
