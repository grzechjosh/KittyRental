class User < ApplicationRecord
      validates :session_token, presence: true
      validates :password_digest, presence: {message: "Password can't be blank."}
      after_initialize :ensure_session_token
      validates :username, uniqueness: true
      
      has_many :cats,
        primary_key: :id,
        foreign_key: :user_id,
        class_name: :Cat
      has_many :cat_rental_requests,
        primary_key: :id,
        foreign_key: :user_id,
        class_name: :CatRentalRequest

      def User.generate_session_token
          SecureRandom::urlsafe_base64(16)
      end
      def ensure_session_token
        self.session_token ||= self.class.generate_session_token
      end
      def reset_session_token!
        self.session_token = self.class.generate_session_token
        self.save
        self.session_token
      end
      def password=(password)
        self.password_digest = BCrypt::Password.create(password)
      end
      def is_password?(password)
        BCrypt::Password.new(self.password_digest).is_password?(password)
      end
      def find_by_credentials(user_name, password)
        user = User.find_by(username: username)
        return nil if user.nil?
        user.is_password?(password) ? user : nil
      end

      
end
