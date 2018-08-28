class Form < ApplicationRecord
  belongs_to :user
  extend FriendlyId
  friendly_id :title, use: :slugged
end
