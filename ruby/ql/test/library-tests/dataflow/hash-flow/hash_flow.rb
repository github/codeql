def taint x
    x
end

def sink x
    puts x
end

def m1()
    hash = {
        :a => taint(1.1),
        :b => 1,
        c: taint(1.2),
        d: 2,
        'e': taint(1.3),
        'f': 3,
        'g' => taint(1.4),
        'h' => 4,
        0 => taint(1.5),
        1 => 5
    }
    sink(hash[:a]) # $ hasValueFlow=1.1
    sink(hash[:b])
    sink(hash[:c]) # $ hasValueFlow=1.2
    sink(hash[:d])
    sink(hash['e']) # $ hasValueFlow=1.3
    sink(hash['f'])
    sink(hash['g']) # $ hasValueFlow=1.4
    sink(hash['h'])
    sink(hash[0]) # $ hasValueFlow=1.5
    sink(hash[1])
end

m1()

def m2()
    hash = Hash.new
    hash[0] = taint(2.1)
    hash[1] = 1
    hash[:a] = taint(2.2)
    hash[:b] = 2
    hash['a'] = taint(2.3)
    hash['b'] = 3
    sink(hash[0]) # $ hasValueFlow=2.1
    sink(hash[1])
    sink(hash[:a]) # $ hasValueFlow=2.2
    sink(hash[:b])
    sink(hash['a']) # $ hasValueFlow=2.3
    sink(hash['b'])
end

m2()

def m3()
    hash1 = Hash[a: taint(3.1), b: 1]
    sink(hash1[:a]) # $ hasValueFlow=3.1
    sink(hash1[:b])

    x = {a: taint(3.2), b: 1}
    hash2 = Hash[x]
    sink(hash2[:a]) # $ hasValueFlow=3.2
    sink(hash2[:b])

    hash3 = Hash[[[:a, taint(3.3)], [:b, 1]]]
    sink(hash3[:a]) # $ hasValueFlow=3.3
    sink(hash3[:b]) # $ SPURIOUS hasValueFlow=3.3

    hash4 = Hash[:a, taint(3.4), :b, 1]
    sink(hash4[:a]) # $ hasValueFlow=3.4
    sink(hash4[:b])

    hash5 = Hash["a" => taint(3.5), "b" => 1]
    sink(hash5["a"]) # $ hasValueFlow=3.5
    sink(hash5["b"])

    hash6 = Hash[{"a" => taint(3.6), "b" => 1}]
    sink(hash6["a"]) # $ hasValueFlow=3.6
    sink(hash6["b"])
end

m3()

def m4()
    hash1 = ::Hash.[](a: taint(4.1), b: 1)
    sink(hash1[:a]) # $ hasValueFlow=4.1
    sink(hash1[:b])
end

m4()

def m5()
    hash = {
        :a => taint(5.1),
        :b => 1
    }
    hash2 = Hash.try_convert(hash)
    sink(hash2[:a]) # $ hasValueFlow=5.1
    sink(hash2[:b])
end

m5()

def m6()
    hash = Hash.new
    b = (hash[:a] = taint(6.1))
    sink(b) # $ hasValueFlow=6.1
end

m6()

def m7(x)
    hash = Hash.new
    b = hash.store(:a, taint(7.1))
    sink(hash[:a]) # $ hasValueFlow=7.1
    sink(b) # $ hasValueFlow=7.1
    hash.store(:a, 1)
    sink(hash[:a])
    c = hash.store(x, taint(7.2))
    sink(hash[:a]) # $ hasValueFlow=7.2
    sink(hash[10]) # $ hasValueFlow=7.2
    sink(c) # $ hasValueFlow=7.2
end

m7("foo")

def m8()
    hash = {
        :a => taint(8.1),
        :b => 1
    }
    hash.any? { |key_or_value|
        sink(key_or_value) # $ hasValueFlow=8.1
    }
    hash.any? { |key,value|
        sink(key)
        sink(value) # $ hasValueFlow=8.1
    }
end

m8()

def m9(x, y)
    hash = {
        :a => taint(10.1),
        :b => 1
    }
    b = hash.assoc(:a)
    sink(b[0])
    sink(b[1]) # $ hasValueFlow=10.1
    sink(b[x]) # $ hasValueFlow=10.1
    c = hash.assoc(y)
    sink(c[1]) # $ hasValueFlow=10.1
end

m9(1, :a)

def m10()
    hash = {
        :a => taint(9.1),
        :b => 1
    }
    hash.clear
    sink(hash[:a])
end

m10()

def m11()
    hash = {
        :a => taint(11.1),
        :b => 1
    }
    a = hash.compact
    sink(a[:a]) # $ hasValueFlow=11.1
    sink(a[:b])
end

m11()

def m12()
    hash = {
        :a => taint(12.1),
        :b => 1
    }
    a = hash.delete(:a)
    sink(a) # $ hasValueFlow=12.1
    sink(hash[:a])
end

m12()

def m13()
    hash = {
        :a => taint(13.1),
        :b => 1
    }
    a = hash.delete_if do |key, value|
        sink key
        sink value # $ hasValueFlow=13.1
    end
    sink(a[:a]) # $ hasValueFlow=13.1
    sink(hash[:a]) # $ hasValueFlow=13.1
    sink(hash[0])
end

m13()

def m14()
    hash = {
        :a => taint(14.1),
        :b => 1,
        :c => {
            :d => taint(14.2),
            :e => 2
        }
    }
    sink(hash.dig(:a)) # $ hasValueFlow=14.1
    sink(hash.dig(:b))
    sink(hash.dig(:c,:d)) # $ hasValueFlow=14.2
    sink(hash.dig(:c,:e))
end

m14()

def m15()
    hash = {
        :a => taint(15.1),
        :b => 1
    }
    x = hash.each do |key, value|
        sink key
        sink value # $ hasValueFlow=15.1
    end
    sink(x[:a]) # $ hasValueFlow=15.1
    sink(x[:b])
end

m15()

def m16()
    hash = {
        :a => taint(16.1),
        :b => 1
    }
    x = hash.each_key do |key|
        sink key
    end
    sink(x[:a]) # $ hasValueFlow=16.1
    sink(x[:b])
end

m16()

def m17()
    hash = {
        :a => taint(17.1),
        :b => 1
    }
    x = hash.each_pair do |key, value|
        sink key
        sink value # $ hasValueFlow=17.1
    end
    sink(x[:a]) # $ hasValueFlow=17.1
    sink(x[:b])
end

m17()

def m18()
    hash = {
        :a => taint(18.1),
        :b => 1
    }
    x = hash.each_value do |value|
        sink value # $ hasValueFlow=18.1
    end
    sink(x[:a]) # $ hasValueFlow=18.1
    sink(x[:b])
end

m18()

def m19(x)
    hash = {
        :a => taint(19.1),
        :b => 1,
        :c => taint(19.2),
        :d => taint(19.3)
    }
    x = hash.except(:a,x,:d)
    sink(x[:a])
    sink(x[:b])
    sink(x[:c]) # $ hasValueFlow=19.2
    sink(x[:d])
end

m19(:c)

def m20(x)
    hash = {
        :a => taint(20.1),
        :b => 1,
        :c => taint(20.2)
    }
    b = hash.fetch(taint(20.3)) do |x|
        sink x # $ hasValueFlow=20.3
    end
    sink(b) # $ hasValueFlow=20.1 $ hasValueFlow=20.2
    b = hash.fetch(:a)
    sink b # $ hasValueFlow=20.1
    b = hash.fetch(:a, taint(20.4))
    sink b # $ hasValueFlow=20.1 $ hasValueFlow=20.4
    b = hash.fetch(:b, taint(20.5))
    sink b # $ hasValueFlow=20.5
    b = hash.fetch(x, taint(20.6))
    sink b # $ hasValueFlow=20.1 $ hasValueFlow=20.2 $ hasValueFlow=20.6
end

m20(:a)

def m21(x)
    hash = {
        :a => taint(21.1),
        :b => 1,
        :c => taint(21.2)
    }
    b = hash.fetch_values(taint(21.3)) do |x|
        sink x # $ hasValueFlow=21.3
        taint(21.4)
    end
    sink(b[0]) # $ hasValueFlow=21.1 $ hasValueFlow=21.2 $ hasValueFlow=21.4
    b = hash.fetch_values(:a)
    sink(b[0]) # $ hasValueFlow=21.1
    b = hash.fetch_values(:a,x)
    sink(b[1]) # $ hasValueFlow=21.1 $ hasValueFlow=21.2
end

m21(:c)

def m22()
    hash = {
        :a => taint(22.1),
        :b => 1,
        :c => taint(22.2)
    }
    b = hash.filter do |key, value|
        sink key
        sink value # $ hasValueFlow=22.1 $ hasValueFlow=22.2
        true
    end
    sink (b[:a]) # $ hasValueFlow=22.1
end

m22()

def m23()
    hash = {
        :a => taint(23.1),
        :b => 1,
        :c => taint(23.2)
    }
    hash.filter! do |key, value|
        sink key
        sink value # $ hasValueFlow=23.1 $ hasValueFlow=23.2
        true
    end
    sink (hash[:a]) # $ hasValueFlow=23.1
end

m23()

def m24()
    hash = {
        :a => taint(24.1),
        :b => 1,
        :c => taint(24.2)
    }
    b = hash.flatten
    sink (b[1]) # $ hasValueFlow=24.1 $ hasValueFlow=24.2
end

m24()

def m25()
    hash = {
        :a => taint(25.1),
        :b => 1,
        :c => taint(25.2)
    }
    b = hash.keep_if do |key, value|
        sink key
        sink value # $ hasValueFlow=25.1 $ hasValueFlow=25.2
        true
    end
    sink (hash[:a]) # $ hasValueFlow=25.1
    sink (b[:a]) # $ hasValueFlow=25.1
end

m25()

def m26()
    hash1 = {
        :a => taint(26.1),
        :b => 1,
        :c => taint(26.2)
    }
    hash2 = {
        :d => taint(26.3),
        :e => 1,
        :f => taint(26.4)
    }
    hash = hash1.merge(hash2) do |key, old_value, new_value|
        sink key
        sink old_value # $ hasValueFlow=26.1 $ hasValueFlow=26.2 $ hasValueFlow=26.3 $ hasValueFlow=26.4
        sink new_value # $ hasValueFlow=26.1 $ hasValueFlow=26.2 $ hasValueFlow=26.3 $ hasValueFlow=26.4
    end
    sink (hash[:a]) # $ hasValueFlow=26.1
    sink (hash[:b])
    sink (hash[:c]) # $ hasValueFlow=26.2
    sink (hash[:d]) # $ hasValueFlow=26.3
    sink (hash[:e])
    sink (hash[:f]) # $ hasValueFlow=26.4
end

m26()

def m27()
    hash1 = {
        :a => taint(27.1),
        :b => 1,
        :c => taint(27.2)
    }
    hash2 = {
        :d => taint(27.3),
        :e => 1,
        :f => taint(27.4)
    }
    hash = hash1.merge!(hash2) do |key, old_value, new_value|
        sink key
        sink old_value # $ hasValueFlow=27.1 $ hasValueFlow=27.2 $ hasValueFlow=27.3 $ hasValueFlow=27.4
        sink new_value # $ hasValueFlow=27.1 $ hasValueFlow=27.2 $ hasValueFlow=27.3 $ hasValueFlow=27.4
    end
    sink (hash[:a]) # $ hasValueFlow=27.1
    sink (hash[:b])
    sink (hash[:c]) # $ hasValueFlow=27.2
    sink (hash[:d]) # $ hasValueFlow=27.3
    sink (hash[:e])
    sink (hash[:f]) # $ hasValueFlow=27.4

    sink (hash1[:a]) # $ hasValueFlow=27.1
    sink (hash1[:b])
    sink (hash1[:c]) # $ hasValueFlow=27.2
    sink (hash1[:d]) # $ hasValueFlow=27.3
    sink (hash1[:e])
    sink (hash1[:f]) # $ hasValueFlow=27.4
end

m27()

def m28
    hash = {
        :a => taint(28.1),
        :b => 1
    }
    b = hash.rassoc(0)
    sink(b[0])
    sink(b[1]) # $ hasValueFlow=28.1
end

m28()

def m29
    hash = {
        :a => taint(29.1),
        :b => 1
    }
    b = hash.reject do |key,value|
        sink key
        sink value # $ hasValueFlow=29.1
        value > 10
    end
    sink b[:a] # $ hasValueFlow=29.1
end

m29()

def m30
    hash = {
        :a => taint(30.1),
        :b => 1
    }
    b = hash.reject! do |key,value|
        sink key
        sink value # $ hasValueFlow=30.1
        value > 10
    end
    sink b[:a] # $ hasValueFlow=30.1
    sink hash[:a] # $ hasValueFlow=30.1
end

m30()

def m31()
    hash = {
        :a => taint(31.1),
        :b => 1,
        :c => taint(31.2)
    }
    hash2 = {
        :c => taint(31.3)
    }
    hash2.replace(hash)
    sink (hash2[:a]) # $ hasValueFlow=31.1
    sink (hash2[:b])
    sink (hash2[:c]) # $ hasValueFlow=31.2
end

def m32()
    hash = {
        :a => taint(32.1),
        :b => 1,
        :c => taint(32.2)
    }
    b = hash.select do |key, value|
        sink key
        sink value # $ hasValueFlow=32.1 $ hasValueFlow=32.2
        true
    end
    sink (b[:a]) # $ hasValueFlow=32.1
end

m32()

def m33()
    hash = {
        :a => taint(33.1),
        :b => 1,
        :c => taint(33.2)
    }
    hash.select! do |key, value|
        sink key
        sink value # $ hasValueFlow=33.1 $ hasValueFlow=33.2
        true
    end
    sink (hash[:a]) # $ hasValueFlow=33.1
end

m33()

def m34()
    hash = {
        :a => taint(34.1),
        :b => 1,
        :c => taint(34.2)
    }
    b = hash.shift
    sink (hash[:a]) # $ hasValueFlow=34.1
    sink (b[0])
    sink (b[1]) # $ hasValueFlow=34.1 $ hasValueFlow=34.2
end

m34()

def m35(x)
    hash = {
        :a => taint(35.1),
        :b => 1,
        :c => taint(35.2)
    }
    b = hash.slice(:a, :b)
    sink (b[:a]) # $ hasValueFlow=35.1
    sink (b[:b])
    sink (b[:c])

    c = hash.slice(:a, x)
    sink (c[:a]) # $ hasValueFlow=35.1
    sink (c[:b])
    sink (c[:c]) # $ hasValueFlow=35.2
end

m35(:c)

def m36()
    hash = {
        :a => taint(36.1),
        :b => 1,
        :c => taint(36.2)
    }
    a = hash.to_a
    sink (a[0][0])
    sink (a[0][1]) # $ hasValueFlow=36.1 $ hasValueFlow=36.2
end

m36()

def m37()
    hash = {
        :a => taint(37.1),
        :b => 1,
        :c => taint(37.2)
    }
    a = hash.to_h
    sink (a[:a]) # $ hasValueFlow=37.1
    sink (a[:b])
    sink (a[:c]) # $ hasValueFlow=37.2

    b = hash.to_h do |key, value|
        sink key
        sink value # $ hasValueFlow=37.1 $ hasValueFlow=37.2
        [:d, taint(37.3)]
    end
    sink (b[:d]) # $ hasValueFlow=37.3
end

m37()

def m38()
    hash = {
        :a => taint(38.1),
        :b => 1,
        :c => taint(38.2)
    }
    a = hash.transform_keys {|key| key.to_s }
    sink (a["a"]) # $ hasValueFlow=38.1 $ hasValueFlow=38.2
    sink (a["b"]) # $ hasValueFlow=38.1 $ hasValueFlow=38.2
    sink (a["c"]) # $ hasValueFlow=38.1 $ hasValueFlow=38.2
end

m38()

def m39()
    hash = {
        :a => taint(39.1),
        :b => 1,
        :c => taint(39.2)
    }
    hash.transform_keys! {|key| key.to_s }
    sink (hash["a"]) # $ hasValueFlow=39.1 $ hasValueFlow=39.2
    sink (hash["b"]) # $ hasValueFlow=39.1 $ hasValueFlow=39.2
    sink (hash["c"]) # $ hasValueFlow=39.1 $ hasValueFlow=39.2
end

m39()

def m40()
    hash = {
        :a => taint(40.1),
        :b => 1,
        :c => taint(40.2)
    }
    b = hash.transform_values do |value|
        sink value # $ hasValueFlow=40.1 $ hasValueFlow=40.2
        taint(40.3)
    end
    sink (hash[:a]) # $ hasValueFlow=40.1
    sink (b[:a]) # $ hasValueFlow=40.3
end

m40()

def m41()
    hash = {
        :a => taint(41.1),
        :b => 1,
        :c => taint(41.2)
    }
    hash.transform_values! do |value|
        sink value # $ hasValueFlow=41.1 $ hasValueFlow=41.2
        taint(41.3)
    end
    sink (hash[:a]) # $ hasValueFlow=41.3
end

m41()

def m42()
    hash1 = {
        :a => taint(42.1),
        :b => 1,
        :c => taint(42.2)
    }
    hash2 = {
        :d => taint(42.3),
        :e => 1,
        :f => taint(42.4)
    }
    hash = hash1.update(hash2) do |key, old_value, new_value|
        sink key
        sink old_value # $ hasValueFlow=42.1 $ hasValueFlow=42.2 $ hasValueFlow=42.3 $ hasValueFlow=42.4
        sink new_value # $ hasValueFlow=42.1 $ hasValueFlow=42.2 $ hasValueFlow=42.3 $ hasValueFlow=42.4
    end
    sink (hash[:a]) # $ hasValueFlow=42.1
    sink (hash[:b])
    sink (hash[:c]) # $ hasValueFlow=42.2
    sink (hash[:d]) # $ hasValueFlow=42.3
    sink (hash[:e])
    sink (hash[:f]) # $ hasValueFlow=42.4

    sink (hash1[:a]) # $ hasValueFlow=42.1
    sink (hash1[:b])
    sink (hash1[:c]) # $ hasValueFlow=42.2
    sink (hash1[:d]) # $ hasValueFlow=42.3
    sink (hash1[:e])
    sink (hash1[:f]) # $ hasValueFlow=42.4
end

m42()

def m43()
    hash = {
        :a => taint(43.1),
        :b => 1,
        :c => taint(43.2)
    }
    a = hash.values
    sink (a[0]) # $ hasValueFlow=43.1 # $ hasValueFlow=43.2
end

m43()

def m44(x)
    hash = {
        :a => taint(44.1),
        :b => 1,
        :c => taint(44.2)
    }
    b = hash.values_at(:a)
    sink(b[0]) # $ hasValueFlow=44.1
    b = hash.fetch_values(:a,x)
    sink(b[1]) # $ hasValueFlow=44.1 $ hasValueFlow=44.2
end

m44(:c)

def m45()
    hash1 = {
        :a => taint(45.1),
        :b => 1,
        :c => taint(45.2)
    }
    hash2 = {
        :d => taint(45.3),
        :e => 2,
        :f => taint(45.4)
    }
    hash = { **hash1, :g => taint(45.5), **hash2, :h => 3 }
    sink(hash[:a]) # $ hasValueFlow=45.1
    sink(hash[:b])
    sink(hash[:c]) # $ hasValueFlow=45.2
    sink(hash[:d]) # $ hasValueFlow=45.3
    sink(hash[:e])
    sink(hash[:f]) # $ hasValueFlow=45.4
    sink(hash[:g]) # $ hasValueFlow=45.5
    sink(hash[:h])
end

m45()