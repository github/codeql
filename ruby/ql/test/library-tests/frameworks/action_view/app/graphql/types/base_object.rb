module Types
  class BaseObject < GraphQL::Schema::Object
    field_class Types::BaseField
  end
end
