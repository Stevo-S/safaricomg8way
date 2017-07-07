class CreateSmsMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :sms_messages do |t|
      t.string :SmsMessage
      t.text :content
      t.string :sender
      t.string :destination
      t.string :link_id

      t.timestamps
    end
  end
end
