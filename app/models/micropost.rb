# encoding utf-8
class Micropost < ActiveRecord::Base
  belongs_to :user
  # 通过 default_scope 设定微博的排序
  # 这种对象叫 Proc 或 lambda，以 -> 开头，后面跟着一个代码块，调用 call 方法时才执行块中的代码
  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :content, length: { maximum: 140}

   def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end
end
