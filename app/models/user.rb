class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :lockable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

  has_one :user_setting, dependent: :destroy
  accepts_nested_attributes_for :user_setting
  has_many :list
  has_many :expenses, dependent: :destroy

  after_create :create_default_user_setting

  def self.from_omniauth(auth)
    user = find_by(provider: auth.provider, uid: auth.uid)
    return user if user

    email = auth.info.email
    user = find_by(email: email)
    if user
      user.update(provider: auth.provider, uid: auth.uid)
      return user
    end

    create(
      email: email,
      password: Devise.friendly_token[0, 20],
      provider: auth.provider,
      uid: auth.uid
    )
  end

  private

  def create_default_user_setting
    create_user_setting(
      default_date_range_list_display: "7",
      default_currency: "USD",
      notification_lead_time: 3
    )
  end
end
