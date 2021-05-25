class CreateGuests < ActiveRecord::Migration[6.0]
  def change
    create_table :guests do |t|
      t.string :email,              null: false, default: ""
      t.string :first_name,         null: false, default: ""
      t.string :last_name,          null: false, default: ""

      t.string :phone_numbers,      array: true

      t.timestamps
    end
  end
end
