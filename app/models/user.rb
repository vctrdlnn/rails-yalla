# user from device, with facebook
class User < ApplicationRecord
  acts_as_voter
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]


  has_many :trips, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :pinned_activities
  has_many :participants
  has_many :invitations, :class_name => 'Invite', :foreign_key => 'recipient_id'
  has_many :sent_invites, :class_name => 'Invite', :foreign_key => 'sender_id'
  has_many :messages

  mount_uploader :photo, PhotoUploader

  validates :username, presence: true, uniqueness: true

  after_create :send_welcome_email

  def name
    if first_name
      first_name + " " + last_name
    else
      username
    end
  end

  def self.find_for_facebook_oauth(auth)
    user_params = auth.to_h.slice(:provider, :uid)
    user_params.merge! auth.info.slice(:email, :first_name, :last_name)
    user_params[:facebook_picture_url] = auth.info.image
    user_params[:token] = auth.credentials.token
    user_params[:token_expiry] = Time.at(auth.credentials.expires_at)

    user = User.where(provider: auth.provider, uid: auth.uid).first
    user ||= User.where(email: auth.info.email).first # User did a regular sign up in the past.
    if user
      user.update(user_params)
    else
      user = User.new(user_params)
      user.password = Devise.friendly_token[0, 20] # Fake password for validation
      # user.username = user.first_name + " " + user.last_name
      user.save
    end
    user
  end

  private

  def send_welcome_email
    UserMailer.welcome(self).deliver_now
  end
end
