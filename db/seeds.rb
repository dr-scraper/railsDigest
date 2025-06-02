User.destroy_all

User.create!(
  email: "amkap12@gmail.com,",
  password: "password"
)

User.create!(
  email: "collincodes9@gmail.com,",
  password: "password"
)

puts "DB has been successfully seeded."
