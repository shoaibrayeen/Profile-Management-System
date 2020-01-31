#require 'elasticsearch/model'
module Searchable
  extend ActiveSupport::Concern
  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
    settings index: { number_of_shards: 1 } do
      mapping dynamic: false do
        indexes :id, type: 'keyword'
        indexes :name, type: 'keyword'
        indexes :email, type: 'keyword'
        indexes :phone, type: 'keyword'
      end
    end
    def self.es_search_result(params)
      field = params[:field]
      query = params[:query]
      data = self.__elasticsearch__.search({
      query: {
      bool: {
                must: [{
                    term: {
                        "#{field}":"#{query}"
                        }
                    }]
                }
            }
        }).records
       return data     
      # ...
    end
  end
end
