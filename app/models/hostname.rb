class Hostname < ApplicationRecord
  has_and_belongs_to_many :records

  validates :address, presence: true, format: { with: /\A[A-Za-z0-9]+\.[A-Za-z][A-Za-z0-9]+\z/i }
end
