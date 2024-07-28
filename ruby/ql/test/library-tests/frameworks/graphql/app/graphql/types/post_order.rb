module Types
    class PostOrder < Types::BaseInputObject
        argument :direction, Types::Direction, "The ordering direction", required: true
    end
end