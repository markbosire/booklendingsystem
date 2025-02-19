# db/seeds.rb

# Clear existing data in the correct order
Borrowing.destroy_all  # Must come first to avoid foreign key violations
Book.destroy_all
User.destroy_all





# Create dummy users
10.times do |i|
  User.create!(
    email_address: "user#{i + 1}@example.com",
    password: "password#{i + 1}",
    password_confirmation: "password#{i + 1}"
  )
end

# Create dummy books
20.times do |i|
  Book.create!(
    title: "Book Title #{i + 1}",
    author: "Author #{i + 1}",
    isbn: "ISBN#{i + 1}"
  )
end

# Create dummy borrowings
users = User.all
books = Book.all

users.each do |user|
  2.times do
    book = books.sample
    Borrowing.create!(
      user: user,
      book: book,
      due_date: 2.weeks.from_now
    )
  end
end

puts "Seeding completed! Created #{User.count} users, #{Book.count} books, and #{Borrowing.count} borrowings."