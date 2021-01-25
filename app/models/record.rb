class Record < ApplicationRecord
  has_and_belongs_to_many :hostnames

  validates :ip, presence: true, format: { with: /\A[\d{,2}|1\d{2}|2[0-4]\d|25[0-5]\.]{3}\d{,2}|1\d{2}|2[0-4]\d|25[0-5]\z/i }

  def self.custom_filter(included, excluded)
    Record.find_by_sql(["
      SELECT records.id, records.ip FROM records
      INNER JOIN hostnames_records ON hostnames_records.record_id = records.id
      INNER JOIN hostnames ON hostnames.id = hostnames_records.hostname_id
      WHERE hostnames.address IN (?)
      GROUP BY records.id
      HAVING count(hostnames.address) = ?
      EXCEPT
      (
        SELECT records.id, records.ip FROM records
        INNER JOIN hostnames_records ON hostnames_records.record_id = records.id
        INNER JOIN hostnames ON hostnames.id = hostnames_records.hostname_id
        WHERE hostnames.address IN (?)
        GROUP BY records.id
        HAVING count(hostnames.address) = ?
      )
      ORDER BY 1 ASC
    ", included, included.length, excluded, excluded.length ])
  end
end
