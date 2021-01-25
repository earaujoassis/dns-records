class AddIndexToHostnamesRecords < ActiveRecord::Migration[6.1]
  def change
    add_index "hostnames_records", [:hostname_id, :record_id], unique: true
  end
end
