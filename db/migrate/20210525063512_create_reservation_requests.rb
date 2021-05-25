class CreateReservationRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :reservation_requests do |t|
      t.jsonb :payload,             null: false

      t.belongs_to :reservation,    foreign_key: true

      t.timestamps
    end
  end
end
