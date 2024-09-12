class User < ApplicationRecord
  has_many :todos

  def self.todos_for_user(user_id)
    user = find(user_id)
    user.todos
  end
end
