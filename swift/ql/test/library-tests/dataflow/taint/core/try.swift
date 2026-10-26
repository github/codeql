func clean() throws -> String { return ""; }
func source() throws -> String { return ""; }
func sink(arg: String) {}

func taintThroughTry() {
	do
	{
		sink(arg: try clean())
		sink(arg: try source()) // $ tainted=9
	} catch {
		// ...
	}

	sink(arg: try! clean())
	sink(arg: try! source()) // $ tainted=15

	sink(arg: (try? clean())!)
	sink(arg: (try? source())!) // $ tainted=18
}
