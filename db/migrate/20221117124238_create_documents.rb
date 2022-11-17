class CreateDocuments < ActiveRecord::Migration[6.0]
  def change
    create_table :documents do |t|
      t.string :key
      t.integer :user_id
      t.boolean :shared

      t.timestamps
    end
    add_index :documents, :key
    add_index :documents, :user_id
  end
end
