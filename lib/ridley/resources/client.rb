module Ridley
  # @author Jamie Winsor <jamie@vialstudios.com>
  class Client < Ridley::Resource
    class << self
      # Retrieves a client from the remote connection matching the given chef_id
      # and regenerates it's private key. An instance of the updated object will
      # be returned and have a value set for the 'private_key' accessor.
      #
      # @param [Ridley::Connection] connection
      # @param [String, #chef_id] client
      #
      # @raise [Errors::HTTPNotFound]
      #   if a client with the given chef_id is not found
      # @raise [Errors::HTTPError]
      #
      # @return [Ridley::Client]
      def regenerate_key(connection, client)
        obj = find!(connection, client)
        obj.regenerate_key
        obj
      end
    end

    set_chef_id "name"
    set_chef_type "client"
    set_chef_json_class "Chef::ApiClient"
    set_resource_path "clients"

    attribute :name,
      type: String,
      required: true

    attribute :admin,
      type: Boolean,
      required: true,
      default: false

    attribute :validator,
      type: Boolean,
      required: true,
      default: false

    attribute :certificate,
      type: String

    attribute :public_key,
      type: String

    attribute :private_key,
      type: String

    attribute :orgname,
      type: String

    # Regenerates the private key of the instantiated client object. The new
    # private key will be set to the value of the 'private_key' accessor
    # of the instantiated client object.
    #
    # @return [Boolean]
    #   true for success and false for failure
    def regenerate_key
      self.private_key = true
      self.save
    end
  end

  module DSL
    # Coerces instance functions into class functions on Ridley::Client. This coercion
    # sends an instance of the including class along to the class function.
    #
    # @see Ridley::ChainLink
    #
    # @return [Ridley::ChainLink]
    #   a context object to delegate instance functions to class functions on Ridley::Client
    def client
      ChainLink.new(self, Ridley::Client)
    end
  end
end
