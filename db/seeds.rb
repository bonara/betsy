# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

merchant_list = [
  [ "nidhiparixitpatel", "Nidhi", 1, "github",  "nidhixpatel@gmail.com"],
  [ "bonara", "Nara", 2, "github",  "email"],
  [ "kate's github", "Kate", 3, "github",  "email"],
  [ "rosayln's github", "Rosalyn", 4, "github",  "email"]
]

merchant_list.each do |username, name, uid, provider, email|
  Merchant.create!(username: username, name: name, uid: uid, provider: provider, email: email )
end

puts "#{Merchant.count} merchants in database"


