class CreateClients < ActiveRecord::Migration[8.1]
  def change
    create_table :clients do |t|
      t.references :firm, null: false, foreign_key: true
      t.string :name
      t.string :company_name
      t.string :email
      t.string :phone
      t.string :status

      t.timestamps
    end
  end
end
