require 'faker'
require 'open-uri'

puts "Nettoyage de la base de données..."
User.destroy_all

puts "Création des utilisateurs (au pairs et familles)..."

# Array of real photo filenames
photo_filenames = ['ap_1.jpeg', 'ap_2.jpeg', 'ap_3.jpeg', 'ap_4.jpeg', 'ap_5.jpeg', 'ap_6.jpeg', 'ap_7.jpeg', 'ap_8.jpeg', 'ap_9.jpeg']

puts "Création des au pairs"
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
    role: "aupair",
    email: Faker::Internet.email,
    password: Faker::Internet.password(min_length: 8)
  )

  if user.save
    # Attacher une photo locale à l'utilisateur
    file_path = Rails.root.join('app', 'assets', 'images', 'aupairs_seeds', photo_filenames[i % photo_filenames.length])
    user.photo.attach(io: File.open(file_path), filename: photo_filenames[i % photo_filenames.length], content_type: 'image/jpeg')

    puts "#{user.first_name} - Au pair #{i + 1} créée !"
  else
    puts "Erreur lors de la création de l'au pair #{i + 1}"
  end
end

puts "Création des familles"
# Créer 10 familles avec des données random
10.times do |i|
  user = User.new(
    last_name: Faker::Name.last_name,
    description: "Nous sommes une famille à la recherche d'une au pair pour nos enfants.",
    nationality: Faker::Nation.nationality,
    location: Faker::Address.city,
    number_of_children: rand(1..4),
    role: "family",
    email: Faker::Internet.email,           # Utilisation de Faker pour un email aléatoire
    password: Faker::Internet.password(min_length: 8) # Mot de passe aléatoire avec Faker
  )

  if user.save
    puts "#{user.last_name} - Famille #{i + 1} créée !"
  else
    puts "Erreur lors de la création de la famille #{i + 1}"
  end
end

puts "Création terminée !"
