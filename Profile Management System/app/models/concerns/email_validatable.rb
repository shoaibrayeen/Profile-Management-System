require 'mail'
=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Email would be Validated From Here!    
=end

module EmailValidatable
  extend ActiveSupport::Concern

  class EmailValidator < ActiveModel::EachValidator

    def validate_each(record, attribute, value)
      begin
        a = Mail::Address.new(value)
      rescue Mail::Field::ParseError
        record.errors[attribute] << (options[:message] || "is not an email")
      end

      # regexp from http://guides.rubyonrails.org/active_record_validations.html
      value = a.address
      unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
        record.errors[attribute] << (options[:message] || "is not an email")
      end
    end

  end
end