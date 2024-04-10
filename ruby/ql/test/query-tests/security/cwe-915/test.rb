class User < ApplicationRecord

end

class UserController < ActionController::Base
    def create
        # BAD: arbitrary params are permitted to be used for this assignment
        User.new(user_params).save!
    end

    def create2
        # GOOD: the permitted parameters are explicitly specified
        User.new(params[:user].permit(:name,:address))
    end

    def create3
        # each BAD
        User.build(user_params)
        User.create(user_params)
        User.create!(user_params)
        User.insert(user_params)
        User.insert!(user_params)
        User.insert_all([user_params])
        User.insert_all!([user_params])
        User.update(user_params)
        User.update(7, user_params)
        User.update!(user_params)
        User.update!(7, user_params)
        User.upsert(user_params)
        User.upsert([user_params])
        User.find_or_create_by(user_params)
        User.find_or_create_by!(user_params)
        User.find_or_initialize_by(user_params)
        User.create_or_find_by(user_params)
        User.create_or_find_by!(user_params)
        User.create_with(user_params)

        user = User.where(name:"abc")
        user.update(user_params)
    end

    def user_params
        params.require(:user).permit!
    end

    def create4
        x = params[:user]
        x.permit!
        User.new(x) # BAD
        User.new(x.permit(:name,:address)) # GOOD
        User.new(params.permit(user: {})) # BAD
        User.new(params.permit(user: [:name, :address, {friends:{}}])) # BAD
        User.new(params.to_unsafe_h) # BAD
        User.new(params.permit(user: [:name, :address]).to_unsafe_h) # GOOD
     end
end