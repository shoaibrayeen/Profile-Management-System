#require 'elasticsearch/model'
class User < ApplicationRecord
    include Searchable
    include EmailValidatable
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    after_commit on: [:create] do
        __elasticsearch__.index_document
    end
    
    after_commit on: [:update] do
        __elasticsearch__.update_document
    end

    validates :name, presence: true, length: { minimum: 3}
    validates :email, email:true, uniqueness: true, presence:true
    validates :phone, presence: true, uniqueness: true, length: { minimum: 10, maximum: 10}
    validates :password, presence: true,  length: { minimum: 6}

    #Syntax
    belongs_to :my_parent, :class_name => :User, :foreign_key => :parent
    has_many :children, :class_name => :User, :foreign_key => :parent # length: {maximum: 4}

    #after_commit :after_commit_tasks
    def self.search_record(params)
        return es_search_result(params)
    end
    def as_indexed_json(options={}) {
        "id" => id,
        "name" => name,
        "email" => email,
        "phone" => phone
    }
    end
    def self.insertion_in_es
        User.__elasticsearch__.client.indices.create \
        index: User.index_name, body: { settings: User.settings.to_hash, mappings: User.mappings.to_hash }
        User.find_each do |i|
            i.__elasticsearch__.index_document
        end
        #puts "#{data}"
        # User.last.__elasticsearch__.index_document
        # User.__elasticsearch__.delete_index!
    end

end

#User.import