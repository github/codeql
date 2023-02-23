module Types
  module BaseInterface
    include GraphQL::Schema::Interface

    field_class Types::BaseField
  end
end
