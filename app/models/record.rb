class Record < ApplicationRecord
  has_and_belongs_to_many :hostnames

  validates :ip, presence: true, format: { with: /\A[\d{,2}|1\d{2}|2[0-4]\d|25[0-5]\.]{3}\d{,2}|1\d{2}|2[0-4]\d|25[0-5]\z/i }
end
