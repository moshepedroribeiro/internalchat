class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.text :description
      t.references :user_sent, index: true, foreign_key: {to_table: :users}
      t.references :user_received, index: true, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
