class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  enum permission_class: [:regular, :loser] # For testing, loser has no permissions

  def user_string
    "stringhere"
  end

end
