module Errdo
  # rubocop:disable MutableConstant
  EXTENSIONS = []
  AUTHORIZATION_ADAPTERS = {}
  # rubocop:enable MutableConstant

  # The extension may define various adapters (e.g., for authorization) and
  # register those via the options hash.
  def self.add_extension(extension_key, extension_definition, options = {})
    options.assert_valid_keys(:authorization)

    EXTENSIONS << extension_key

    if options[:authorization]
      AUTHORIZATION_ADAPTERS[extension_key] = extension_definition::AuthorizationAdapter
    end
  end
end
