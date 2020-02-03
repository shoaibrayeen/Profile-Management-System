require 'bcrypt'
class User < ApplicationRecord
    has_secure_password

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Including All the Module to be used  
=end

    include Searchable
    include EmailValidatable
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Insertion in Elastic Search Doc   
=end

    after_commit on: [:create] do
        __elasticsearch__.index_document
    end
    
    after_commit on: [:update] do
        __elasticsearch__.update_document
    end

    after_commit on: [:destroy] do
        __elasticsearch__.delete_document
    end
    
=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Validation for User Table    
=end
    validates :name, presence: true, length: { minimum: 3}
    validates :email, email:true, uniqueness: true, presence:true
    validates :contact, presence: true, :numericality => true, uniqueness: true, length: { minimum: 10, maximum: 10}
    validates :password, presence: true,  length: { minimum: 6}
    validates :user_type, presence: true


=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Seaching from ES  
=end

    def self.search_record(params)
        return es_search_result(params)
    end

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Creating JSON for ES    
=end

    def as_indexed_json(options={}) {
        "id" => id,
        "name" => name,
        "email" => email,
        "contact" => contact
    }
    end

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Creating Empty Doc Acc. to the mapping   
=end
    def self.es_doc_creation
        User.__elasticsearch__.client.indices.create \
        index: User.index_name, body: { settings: User.settings.to_hash, mappings: User.mappings.to_hash }
    end

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Code to Create New User -> used by Admin and User Controller  
=end

    def self.sign_up(params)
        user = User.new
        user.name = params[:name].strip
        user.email = params[:email].strip
        user.contact = params[:contact].strip
        user.password = params[:password].strip
        user.user_type = params[:user_type]
        user.status = "activate"
        if params[:parent_id] != nil
            if params[:parent_id] != ""
                if self.get_user_info_by_id(params[:parent_id]).nil?
                    return nil
                else
                    if self.checking_profile_hierarchy(params[:parent_id]) == true
                        user.parent_id = params[:parent_id]
                    else
                        return "404"
                    end
                end
            end
        end

        if user.save
            return true
        else
            return false
        end
    end

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Sigin Method -> used by Admin and User Controller  
=end

    def self.sign_in(params)
        field = params[:field]
        user = User.find_by("#{field}" => params[:value])
        if user == nil
          return nil                
        else
          if user.authenticate(params[:password]) && user.status == "activate"
            return true
          else
            return false
          end
        end
    end

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Taking Data From User Table using id -> used by Admin and User Controller  
=end

    def self.get_user_info_by_id(user_id)
        user = User.find_by(id: user_id)
    end

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Getting data on the basis of field-> used by Admin and User Controller  
=end
    def self.get_user_info_by_field(field, value)
        user = User.find_by("#{field}" => "#{value}")
    end

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** All Data -> used by Admin and User Controller  
=end
    def self.get_all_user_info
        return User.all
    end


=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Updating Data in User Table -> used by Admin and User Controller  
=end
    def self.update_info(params)
        user = get_user_info_by_id(params[:id])
        user.name = params[:name].strip
        user.email = params[:email].strip
        user.contact = params[:contact].strip
        user.password = params[:password].strip
        user.user_type = params[:user_type]
        if user.status == nil
            user.status = params[:status]
        else
            user.status = "activate"
        end
        if params[:parent_id] != nil
            if params[:parent_id] != ""
                if self.get_user_info_by_id(params[:parent_id]).nil?
                    return nil
                else
                    if self.checking_profile_hierarchy(params[:parent_id]) == true
                        user.parent_id = params[:parent_id]
                    else
                        return "404"
                    end
                end
            end
        end

        if user.save
            return true
        else
            return false
        end
    end

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Checking profile Hierarchy
=end

    def self.checking_profile_hierarchy(new_parent_id)
        parent_info = get_user_info_by_id(new_parent_id)
        # If there is no grandparent!
        if parent_info == nil
            return true
        end

        grandparent_info = get_user_info_by_id(parent_info.parent_id)
        if grandparent_info == nil
            return true

        else
            grand_grand_parent = get_user_info_by_id(grandparent_info.parent_id)
            if grand_grand_parent == nil
               return true
            else                
                # 2 Vertical Level
                return false
            end
        end

    end

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Report Generation using Sidekiq
=end

    def self.report_generator
        return User.where(created_at: Date.today.all_day ).count
    end

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** getting Number of Child
=end

    def self.get_child_count(user_parent_id)

        return User.where(parent_id: user_parent_id ).count
    end

end
