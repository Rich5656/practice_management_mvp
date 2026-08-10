class Client < ApplicationRecord
  belongs_to :firm
  has_many :notes, dependent: :destroy
end
