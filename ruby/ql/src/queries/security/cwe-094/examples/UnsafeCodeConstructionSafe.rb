require 'json'

module MyLib
    def safeDeserialize(value)
        JSON.parse(value)
    end

    def safeGetter(obj, path)
        obj.dig(*path.split("."))
    end
end
