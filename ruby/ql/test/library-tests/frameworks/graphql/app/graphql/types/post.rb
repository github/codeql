class Types::Post < GraphQL::Schema::Object
    field :title, String
    field :body, String, null: false
    field :media_category, Types::MediaCategory, null: false
    field :direction, Types::Direction, null: false
  end
end
  