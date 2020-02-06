module UsersHelper
    def self.hash(user_password)
        require 'digest/md5'
        password_hash = Digest::MD5.hexdigest(user_password)
        return password_hash
    end
end
