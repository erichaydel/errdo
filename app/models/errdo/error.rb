module Errdo
  class Error < ActiveRecord::Base

    require 'digest/sha1'

    self.table_name = Errdo.error_name

    serialize :backtrace

    has_many :error_occurrences

    before_validation :create_unique_string

    validates :backtrace_hash, uniqueness: true

    def self.find_or_create(params)
      unique_string = create_unique_string_from_params(params)

      @error = Errdo::Error.find_by(backtrace_hash: unique_string)
      @error = Errdo::Error.create(params) if @error.nil?

      return @error
    end

    # I need a more elegant way to do this
    def self.create_unique_string_from_params(params)
      params[:backtrace][0].to_s + params[:exception_message].to_s + params[:exception_class_name].to_s
    end

    private

    def create_unique_string
      self.backtrace_hash = backtrace.to_a[0].to_s +
                            exception_message.to_s +
                            exception_class_name.to_s
    end

  end
end
