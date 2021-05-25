class CreateReservations < ActiveRecord::Migration[6.0]
  def change
    create_table :reservations do |t|
      t.date    :start_date,         null: false
      t.date    :end_date,           null: false

      t.integer :guests,             null: false, default: 0
      t.integer :adults,             null: false, default: 0
      t.integer :children,           null: false, default: 0
      t.integer :infants,            null: false, default: 0
      t.integer :nights,             null: false, default: 0

      t.string  :status,             null: false

      t.jsonb   :guest_details,      null: false, default: {}

      t.string  :currency,           null: false
      t.decimal :payout_amount,      null: false, precision: 10, scale: 2
      t.decimal :security_amount,    null: false, precision: 10, scale: 2
      t.decimal :total_amount,       null: false, precision: 10, scale: 2

      t.jsonb   :misc,               null: false, default: {}

      t.belongs_to :guest,           null: false, foreign_key: true
      t.belongs_to :reservation_request, null: false, foreign_key: true

      t.index [:start_date, :end_date, :guest_id], unique: true

      t.timestamps
    end
  end
end
