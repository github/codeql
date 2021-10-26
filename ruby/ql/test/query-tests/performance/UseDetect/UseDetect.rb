
class DetectTest
    def test
        # These are bad
        [].select { |i| true }.first
        [].select { |i| true }.last
        [].select { |i| true }[0]
        [].select { |i| true }[-1]
        [].filter { |i| true }.first
        [].find_all { |i| true }.last
        selection1 = [].select { |i| true }
        selection1.first

        # These are good
        [].select("").first # Selecting a string
        [].select { |i| true }[1] # Selecting the second element
        selection2 = [].select { |i| true }
        selection2.first # Selection used elsewhere
        selection3 = selection2
    end
end
