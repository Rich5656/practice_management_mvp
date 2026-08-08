class Firm < ApplicationRecord
    has_many :users, dependent: :destroy
    has_many  :clients, dependent: :destroy
end
