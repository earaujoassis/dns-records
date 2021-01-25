class CreateHostnamesRecords < ActiveRecord::Migration[6.1]
  def change
    create_join_table :hostnames, :records
  end
end
