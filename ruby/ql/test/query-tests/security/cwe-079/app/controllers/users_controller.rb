class UsersController < ApplicationController
  def index
    render template: "users/custom_index", assigns: { users: params[:users] }, locals: { foo: params[:foo] }
    ApplicationController.renderer.render(template: "users/custom_index", locals: { people: params[:users] })
  end
end
