class PhotosController < ApplicationController
  after_action :foo
  def show
    @a = 1
    @b = 2
  end

  def foo
  end
end