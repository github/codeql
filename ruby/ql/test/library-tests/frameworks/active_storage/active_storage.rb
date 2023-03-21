class User < ActiveRecord::Base
  has_one_attached :avatar
end

class Post < ActiveRecord::Base
  has_many_attached :images
end

user = User.find(id)

user_avatar = user.avatar

user_avatar.preview
user_avatar.representation
user_avatar.variant

user.avatar.variant(resize_to_limit: [128, 128])

attachment = ActiveStorage::Attachment.new

transformations = [{ resize_to_limit: [128, 128] }, { gaussblur: 3 }]

variant = attachment.variant(resize_to_limit: [128, 128])
preview = attachment.preview(gaussblur: 0.3)
representation = attachment.representation(crop: "300x300")

variation = ActiveStorage::Variation.new
variation.transformations = transformations

transformer = ActiveStorage::Transformers::ImageProcessingTransformer.new(transformations)
preview = ActiveStorage::Preview.new(transformations)
variant = ActiveStorage::VariantWithRecord.new(transformations)

ActiveStorage.paths = { minimagick: custom_minimagick_path }
ActiveStorage.video_preview_arguments = custom_preview_args

ActiveStorage.variant_processor = custom_processor

class PostsController2 < ActionController::Base
  def create
    post = Post.new(params[:post])
    post.images.attach(params[:images])
    post.save
  end
end

filename = ActiveStorage::Filename.new(raw_path)
filename.sanitized

ActiveStorage::Blob.create_after_unfurling!(io: file, filename: "foo.jpg")
blob = ActiveStorage::Blob.create_and_upload!(io: file, filename: "foo.jpg")

blob.upload
blob.upload_without_unfurling
blob.download
blob.download_chunk
blob.delete
blob.purge

blob = ActiveStorage::Blob.create_before_direct_upload!(io: file, filename: "foo.jpg")
blob.upload

blob = ActiveStorage::Blob.compose([blob1, blob2])
blob1.upload # not recognised currently
blob.upload

blob = ActiveStorage::Blob.find_signed(id)
blob.upload

blob = ActiveStorage::Blob.find_signed!(id)
blob.upload

attachment.blob.upload
attachment.upload
