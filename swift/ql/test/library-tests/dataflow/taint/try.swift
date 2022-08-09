func clean() throws -> String { return ""; }
func source() throws -> String { return ""; }
func sink(arg: String) {}

func taintThroughTry() {
	do
	{
		sink(arg: try clean())
		sink(arg: try source()) // tainted
	} catch {
		// ...
	}

	sink(arg: try! clean())
	sink(arg: try! source()) // tainted

	sink(arg: (try? clean())!)
	sink(arg: (try? source())!) // tainted
}
