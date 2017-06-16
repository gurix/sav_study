class Newsletter
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email, type: String
end
