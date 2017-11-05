class Lead < ApplicationRecord
  validates_uniqueness_of :subject

  belongs_to :user
end
