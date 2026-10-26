
class User < ActiveRecord::Base
end

class DatabaseQueryInLoopTest
    def test
        ### These are bad

        # simple query in loop
        names.map do |name|
            User.where(login: name).pluck(:id).first # $ Alert
        end
        
        # nested loop
        names.map do |name|
            user = User.where(login: name).pluck(:id).first # $ Alert

            ids.map do |user_id|
                User.where(id: user_id).pluck(:id).first # $ Alert
            end
        end

        ### These are OK

        # Not in loop
        User.where(login: owner_slug).pluck(:id).first

        # Loops over constant array
        %w(first-name second-name).map { |name| User.where(login: name).pluck(:id).first }

        constant_names = [first-name, second-name]
        constant_names.each do |name|
            User.where(login: name).pluck(:id).first
          end

        # Loop traversal is influenced by query result
        # raising an exception if the user is not found
        names.map do |name|
            user = User.where(login: name).pluck(:id).first
            unless user
                raise Error.new("User '#{name}' not found")
            end
        end

        # more complicated condition
        names.map do |name|
            user = User.where(login: name).pluck(:id).first
            unless cond && user
                raise Error.new("User '#{name}' not found")
            end
        end

        # skipping through the loop when users are not relevant
        names.map do |name|
            user = User.where(login: name).pluck(:id).first
            if not isRelevant(user)
                next
            end
        end
    end
end
