class Transactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.references :user, foreign_key: true
      t.string :charge_id
      t.decimal :amount
      t.string :currency
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
