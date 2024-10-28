class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :user_setting, dependent: :destroy
  accepts_nested_attributes_for :user_setting
  has_many :list

  after_create :create_default_user_setting

  private

  def create_default_user_setting
    create_user_setting(
      default_date_range_list_display: "7",
      default_currency: "USD",
      notification_lead_time: 3
    )
  end
end
