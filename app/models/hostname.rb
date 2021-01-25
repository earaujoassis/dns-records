class Hostname < ApplicationRecord
  has_and_belongs_to_many :records

  validates :address, presence: true, format: { with: /\A[A-Za-z0-9]+\.[A-Za-z][A-Za-z0-9]+\z/i }

  def self.filter_related_hostnames(included, excluded)
    Hostname.find_by_sql(["
      SELECT hostnames.id, hostnames.address FROM hostnames
      INNER JOIN hostnames_records ON hostnames_records.hostname_id = hostnames.id
      INNER JOIN records ON records.id = hostnames_records.record_id
      WHERE hostnames.address NOT IN (?) AND records.id IN (SELECT records.id FROM records
        INNER JOIN hostnames_records ON hostnames_records.record_id = records.id
        INNER JOIN hostnames ON hostnames.id = hostnames_records.hostname_id
        WHERE hostnames.address IN (?)
        GROUP BY records.id
        HAVING count(hostnames.address) = ?
        EXCEPT
        (
          SELECT records.id FROM records
          INNER JOIN hostnames_records ON hostnames_records.record_id = records.id
          INNER JOIN hostnames ON hostnames.id = hostnames_records.hostname_id
          WHERE hostnames.address IN (?)
          GROUP BY records.id
          HAVING count(hostnames.address) = ?
        )
      )
    ", included, included, included.length, excluded, excluded.length])
  end
end
