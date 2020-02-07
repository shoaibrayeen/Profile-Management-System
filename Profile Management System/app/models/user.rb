require 'bcrypt'
class User < ApplicationRecord
    #has_secure_password

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
  **Common Name:** Validation for User Table    
=end
    validates :name, presence: true, length: { minimum: 3}
    validates :email, email:true, uniqueness: true, presence:true
    validates :contact, presence: true, :numericality => true, uniqueness: true, length: { minimum: 10, maximum: 10}
    validates :user_type, presence: true
    #validates :password, presence: true,  length: { minimum: 6}


=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Insertion in Elastic Search Doc   
=end

    after_commit on: [:create] do
        ElasticSearchUpdaterWorker.perform_async("create" , self.id)
        #__elasticsearch__.index_document
        ReportGeneratorWorker.perform_async
    end
    
    after_commit on: [:update] do
        #__elasticsearch__.update_document
        ElasticSearchUpdaterWorker.perform_async("update", self.id)
    end

    after_commit on: [:destroy] do
        #__elasticsearch__.delete_document
        ElasticSearchUpdaterWorker.perform_async("destroy" , self.id)
    end


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
        index: User.index_name,  body: { settings: User.settings.to_hash, mappings: User.mappings.to_hash}
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
        user.password = UsersHelper.hash(params[:password].strip)
        user.user_type = params[:user_type]
        user.status = "Active"
        user.parent_id = ""
        user.save
    end

    def self.sign_in_validation(query)
        data = self.__elasticsearch__.search(
          {
            query: {
            multi_match: {
              query:    "#{query}", 
              fields: [ "email.keyword", "contact.keyword" ]
              }
            }
          }
        ).records
        return data   
    end
  
    def self.id_validation(params)
        data = self.__elasticsearch__.search(
          {
            query: {
            match: {
              id:    "#{params}"
              }
            }
          }
        ).records
        return data
    end
    
=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Sigin Method -> used by Admin and User Controller  
=end

    def self.sign_in(params)
        @user = sign_in_validation(params[:value])
        if !@user.first
            return "404"
        end
        
        user = get_user_info_by_id("#{@user[0][:id]}")
        if user.email != params[:value] and user.contact != params[:value]
            return "404"
        elsif user.password == UsersHelper.hash(params[:password].strip) && user.status == "Active"
            return user.id
        elsif user.status == "Inactive"
            return "405"
        else
            return "406"
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
  **Common Name:** All Data -> used by Admin and User Controller  
=end
    def self.get_all_user_info
        return User.all
    end

    def self.update_user_password(params)
        user = get_user_info_by_id(params[:id])
        user.update_columns(password: params[:password])
    end


    def self.update_user_bio(params)
        user = get_user_info_by_id(params[:id])
        user.name = params[:name].strip
        user.email = params[:email].strip
        user.contact = params[:contact].strip
        user.user_type = params[:user_type]
        user.save
    end



=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Changing Status of the Person
=end

    def self.user_deactivate(params)
        user = get_user_info_by_id(params[:id])
        if user.nil?
            return "400"
        elsif user.status == 'Inactive'
            user.update_columns(status: 'Active')
            return "501"
        else
            user.update_columns(status: 'Inactive')
            return "502"
        end
    end
=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** updating Parent
=end
    def self.update_user_parent(new_parent_id)
        self.update_columns(parent_id: new_parent_id)
    end

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** getting Number of Child
=end

    def self.get_child_count(user_parent_id)
        return User.where(parent_id: user_parent_id ).count
    end

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Checking profile Hierarchy
=end

    def self.checking_vertical_hierarchy(user_id, user_parent_id)
        #byebug
        # check_child_id.id < user_id < user_parent_id < user_parent_id.parent
        child = User.where(parent_id: user_id).first
        parent_info = User.find_by(id: user_parent_id)
        grandparent = nil
        if parent_info.parent_id != ""
            #Checking Grandparent
            grandparent = User.find_by(id: parent_info.parent_id )
        else
            #GGC should be null then true
            if child.nil?
                return true
            else
                grandchild = User.where(parent_id: child.id).first
                if grandchild.nil?
                    puts "#{child.id}"
                    return true
                end
            end
        end

        if child.nil? and !grandparent.nil? and grandparent.parent_id == ""
            # GC should be null for true 
            return true
        end
        return false
    end

end
