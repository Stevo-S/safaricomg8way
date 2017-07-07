class CreateShortCodes < ActiveRecord::Migration[5.1]
  def change
    create_table :short_codes do |t|
      t.string :code, limit: 6
      t.boolean :activated

      t.timestamps
    end
  end
end
