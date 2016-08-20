require 'errdo/extensions/cancancan/authorization_adapter'

Errdo.add_extension(:cancan, Errdo::Extensions::CanCanCan, authorization: true)
