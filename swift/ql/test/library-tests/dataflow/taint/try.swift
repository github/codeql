func clean() throws -> String { return ""; }
func source() throws -> String { return ""; }
func sink(arg: String) {}

func taintThroughTry() {
	do
	{
		sink(arg: try clean())
		sink(arg: try source()) // $ taintedFromLine=9
	} catch {
		// ...
	}

	sink(arg: try! clean())
	sink(arg: try! source()) // $ taintedFromLine=15

	sink(arg: (try? clean())!)
	sink(arg: (try? source())!) // $ taintedFromLine=18
}
