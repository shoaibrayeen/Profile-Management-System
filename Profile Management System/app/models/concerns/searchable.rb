=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** ES Search and Mapping can be modified from here!  
=end

module Searchable
  extend ActiveSupport::Concern
  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    settings index: {
    number_of_shards: 1,
    number_of_replicas: 0,
    max_ngram_diff: 17,
    analysis: {
     analyzer: {
        pattern: {
           type: 'pattern',
           pattern: "\\s|@|_|-|\\.",
           lowercase: true
          },
          ngram_var: {
            tokenizer: 'ngram_var'
          }
        },
        tokenizer: {
          ngram_var: {
            type: 'ngram',
            min_gram: 3,
            max_gram: 20,
            token_chars: ['letter', 'digit']
          }
        }
      } 
    } do
    mapping do
      indexes :id, type: 'keyword'
      indexes :name, type: 'text', analyzer: 'english' do
        indexes :keyword, analyzer: 'keyword'
        indexes :pattern, analyzer: 'pattern'
        indexes :ngram_var, analyzer: 'ngram_var'

      end
      indexes :email, type: 'text', analyzer: 'english' do
        indexes :keyword, analyzer: 'keyword'
        indexes :pattern, analyzer: 'pattern'
        indexes :ngram_var, analyzer: 'ngram_var'
      end
      indexes :contact, type: 'text', analyzer: 'english' do
        indexes :keyword, analyzer: 'keyword'
        indexes :pattern, analyzer: 'pattern'
        indexes :ngram_var, analyzer: 'ngram_var'
      end
    end
  end


    def self.es_search_result(params)
      query = params[:query]
      data = self.__elasticsearch__.search(
        {
          query: {
          multi_match: {
            query:    "#{query}", 
            fields: [ "email.ngram_var", "name.ngram_var", "contact.ngram_var" ]
            }
          }
        }
      ).records
       return data     
    end

  end
end
