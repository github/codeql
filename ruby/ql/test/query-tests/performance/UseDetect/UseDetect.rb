
class DetectTest
    def test
        # These are bad
        [].select { |i| true }.first # $ Alert
        [].select { |i| true }.last # $ Alert
        [].select { |i| true }[0] # $ Alert
        [].select { |i| true }[-1] # $ Alert
        [].filter { |i| true }.first # $ Alert
        [].find_all { |i| true }.last # $ Alert
        selection1 = [].select { |i| true }
        selection1.first # $ Alert

        # These are good
        [].select("").first # Selecting a string
        [].select { |i| true }[1] # Selecting the second element
        selection2 = [].select { |i| true }
        selection2.first # Selection used elsewhere
        selection3 = selection2
    end
end
