class Author < ActiveRecord::Base
  has_many :posts
end

class Post < ActiveRecord::Base
  belongs_to :author
  has_many :comments
  has_and_belongs_to_many :tags
end

class Tag < ActiveRecord::Base
  has_and_belongs_to_many :posts
end

class Comment < ActiveRecord::Base
  belongs_to :post
end

author1 = Author.new

post1 = author1.posts.create

comment1 = post1.comments.create

author2 = post1.author

post2 = author2.posts.create

author2.posts << post2

post1.author = author2

# The final method call in this chain should not be recognised as an
# instantiation.
post2.comments.create.create

author1.posts.reload.create

post1.build_tag
post1.build_tag

author1.posts.push(post2)
author1.posts.concat(post2)
author1.posts.build
author1.posts.create
author1.posts.create!
author1.posts.delete
author1.posts.delete_all
author1.posts.destroy
author1.posts.destroy_all
author1.posts.distinct.find(post_id)
author1.posts.reset.find(post_id)
author1.posts.reload.find(post_id)
