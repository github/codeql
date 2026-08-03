class User < ApplicationRecord

end

class UserController < ActionController::Base
    def create
        # BAD: arbitrary params are permitted to be used for this assignment
        User.new(user_params).save! # $ Alert
    end

    def create2
        # GOOD: the permitted parameters are explicitly specified
        User.new(params[:user].permit(:name,:address))
    end

    def create3
        # each BAD
        User.build(user_params) # $ Alert
        User.create(user_params) # $ Alert
        User.create!(user_params) # $ Alert
        User.insert(user_params) # $ Alert
        User.insert!(user_params) # $ Alert
        User.insert_all([user_params])
        User.insert_all!([user_params])
        User.update(user_params) # $ Alert
        User.update(7, user_params) # $ Alert
        User.update!(user_params) # $ Alert
        User.update!(7, user_params) # $ Alert
        User.upsert(user_params) # $ Alert
        User.upsert([user_params])
        User.find_or_create_by(user_params) # $ Alert
        User.find_or_create_by!(user_params) # $ Alert
        User.find_or_initialize_by(user_params) # $ Alert
        User.create_or_find_by(user_params) # $ Alert
        User.create_or_find_by!(user_params) # $ Alert
        User.create_with(user_params) # $ Alert

        user = User.where(name:"abc")
        user.update(user_params)
    end

    def user_params
        params.require(:user).permit! # $ Source
    end

    def create4
        x = params[:user] # $ Source
        x.permit!
        User.new(x) # $ Alert // BAD
        User.new(x.permit(:name,:address)) # GOOD
        User.new(params.permit(user: {})) # $ Alert // BAD
        User.new(params.permit(user: [:name, :address, {friends:{}}])) # $ Alert // BAD
        User.new(params.to_unsafe_h) # $ Alert // BAD
        User.new(params.permit(user: [:name, :address]).to_unsafe_h) # GOOD
     end
end
