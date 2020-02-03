=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Admin Table 
=end
class Admin < ApplicationRecord

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Validation for Admin Table  
=end

    has_secure_password
    validates :name, presence: true, length: { minimum: 3}
    validates :username, uniqueness: true, presence:true, length: { minimum: 3}
    validates :password, presence: true,  length: { minimum: 6}

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Admin Sign Up
=end

    def self.sign_up(params)
        admin = Admin.new
        admin.name = params[:name].strip
        admin.username = params[:username].strip
        admin.password = params[:password].strip
        if admin.save
            return true
        else
            return false
        end
    end

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Admin Sign In  
=end

    def self.sign_in(params)
        admin = Admin.find_by(username: params[:username])
        if admin == nil
          return nil                
        else
          if admin.authenticate(params[:password])
            return true
          else
            return false
          end
        end
    end



=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Taking data using Admin username 
=end


    def self.get_admin_info_by_username(admin_username)
        admin = Admin.find_by(username: admin_username)
    end

end
