
class DetectTest
    def test
        # These are bad
        [].select { |i| true }.first
        [].select { |i| true }.last
        [].select { |i| true }[0]
        [].select { |i| true }[-1]
        [].filter { |i| true }.first
        [].find_all { |i| true }.last

        # These are good
        [].select("").first
        [].select { |i| true }[1]
    end
end
