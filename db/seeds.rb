# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'
require 'open-uri'

puts "Nettoyage de la base de données..."
User.destroy_all

puts "Création des utilisateurs (au pairs et familles)..."

# Array of real photo filenames
photo_filenames = ['ap_1.jpeg', 'ap_2.jpeg', 'ap_3.jpeg', 'ap_4.jpeg', 'ap_5.jpeg', 'ap_6.jpeg', 'ap_7.jpeg', 'ap_8.jpeg', 'ap_9.jpeg']

# Créer 8 au pairs avec des photos random
8.times do |i|
  user = User.new(
    first_name: Faker::Name.female_first_name,
    last_name: Faker::Name.last_name,
    birth_date: Faker::Date.birthday(min_age: 18, max_age: 30),
    description: Faker::Lorem.sentence(word_count: 15),
    nationality: Faker::Address.country,
    gender: "Femme",
    location: Faker::Address.city,
    role: "aupair"
  )
  # Adding email and password
  user.email = "#{user.first_name}@gmail.com"
  user.password = 'password'

  # Saving the new user to database
  user.save

  # Attach a real local photo from assets
  file_path = Rails.root.join('app', 'assets', 'images', 'aupairs_seeds', photo_filenames[i % photo_filenames.length])
  user.photo.attach(io: File.open(file_path), filename: photo_filenames[i % photo_filenames.length], content_type: 'image/jpeg')

  user.save ? (puts "#{user.first_name} - Au pair #{i + 1} créée !") : (puts "Au pair non créée")
end

# Créer 10 familles avec des données random
10.times do |i|
  user = User.new(
    last_name: Faker::Name.last_name,
    description: "Nous sommes une famille à la recherche d'une au pair pour nos enfants.",
    nationality: Faker::Nation.nationality,
    location: Faker::Address.city,
    number_of_children: rand(1..4),
    role: "family"
  )
  # Adding email and password
  user.email = "#{user.first_name}@gmail.com"
  user.password = 'password'

  # Saving the new user to database
  user.save ? (puts "#{user.first_name} - Famille #{i + 1} créée") : (puts "Famille non créée")
end

puts "Création terminée !"
