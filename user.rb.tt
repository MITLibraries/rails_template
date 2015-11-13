class User < ActiveRecord::Base
  devise :omniauthable, :omniauth_providers => [:mit_oauth2]

  def self.from_omniauth(auth)
    where(uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
    end
  end
end
