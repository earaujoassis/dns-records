class CreateHostnames < ActiveRecord::Migration[6.1]
  def change
    create_table :hostnames do |t|
      t.string :address

      t.timestamps
    end

    add_index :hostnames, :address, unique: true
  end
end
