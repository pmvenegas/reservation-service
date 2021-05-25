class CreateReservationRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :reservation_requests do |t|
      t.jsonb :payload,             null: false

      t.timestamps
    end
  end
end
