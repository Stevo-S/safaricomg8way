class SmsMessage < ApplicationRecord
    validates :destination, presence: true
    validates :sender, presence: true
end
