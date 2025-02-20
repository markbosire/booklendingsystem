class Borrowing < ApplicationRecord
  belongs_to :user
  belongs_to :book
  validates :user_id, :book_id, :due_date, presence: true
end
