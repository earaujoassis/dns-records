class CreateRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :records do |t|
      t.string :ip

      t.timestamps
    end

    add_index :records, :ip, unique: true
  end
end
