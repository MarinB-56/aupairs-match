require 'faker'
require 'open-uri'
require 'net/http'
require 'json'

# On définit une fonction qui appelle l'API randomuser pour récupérer un lot d'utilisateurs
def fetch_random_users(batch_size: 1000)
  url = URI("https://randomuser.me/api/?nat=us,gb,fr,es,de&inc=gender,name,location,email,login,dob,nat,picture&results=#{batch_size}&noinfo")
  response = Net::HTTP.get(url)
  JSON.parse(response)['results']
end

# On filtre les utilisateurs pour ne garder que ceux dans la tranche d'âge
def filter_users_by_age(users, age_min: 18, age_max: 30)
  users.select do |user|
    age = user['dob']['age']
    age >= age_min && age <= age_max
  end
end

puts "Nettoyage de la base de données..."
User.destroy_all
Language.destroy_all
Availability.destroy_all
UserLanguage.destroy_all

puts "Création des utilisateurs (au pairs et familles)..."

puts "Création des au pairs"

# Récupérer un lot d'utilisateurs depuis l'API
random_users = fetch_random_users(batch_size: 1000)
# Filtrer les utilisateurs par tranche d'âge
filtered_users = filter_users_by_age(random_users, age_min: 18, age_max: 30)

# Si moins de 10 utilisateurs dans la tranche d'âge, afficher un message
if filtered_users.size < 10
  puts "Attention : Moins de 10 utilisateurs disponibles dans la tranche d'âge sélectionnée."
end

# Créer 10 au pairs avec les utilisateurs filtrés
filtered_users.first(10).each_with_index do |random_user, i|
  # Les données de localisations sont reconstruites à partir de la réponse de l'API
  location = random_user['location']
  full_location = "#{location['street']['number']} #{location['street']['name']}, #{location['city']}, #{location['state']}, #{location['country']}"

  # Parse la date d'anniversaire pour nous assurer que le format est correct
  birth_date = Date.parse(random_user['dob']['date'])

  user = User.new(
    first_name: random_user['name']['first'],
    last_name: random_user['name']['last'],
    birth_date: birth_date,
    description: Faker::Lorem.sentence(word_count: 15),
    nationality: random_user['nat'],
    gender: random_user['gender'],
    location: full_location,
    role: "aupair",
    email: random_user['email'],
    password: "password"
  )

  if user.save
    # Attacher une photo depuis l'API randomuser
    user.photo.attach(io: URI.open(random_user['picture']['large']), filename: "aupair_#{i + 1}.jpg", content_type: 'image/jpeg')
    puts "#{user.first_name} #{user.last_name} - Au pair #{i + 1} créée avec succès!"

    # Ajout des langues pour chaque au pair
    languages = ['English', 'Spanish', 'French', 'German', 'Italian'].sample(rand(1..3))
    languages.each do |language|
      lang = Language.find_or_create_by!(language: language)
      UserLanguage.create!(user: user, language: lang)
    end

    # Ajout des disponibilités pour chaque au pair
    Availability.create!(
      user: user,
      start: Faker::Date.between(from: Date.today, to: 1.month.from_now),
      end: Faker::Date.between(from: 2.months.from_now, to: 6.months.from_now)
    )
  else
    puts "Erreur lors de la création de l'au pair #{i + 1}: #{user.errors.full_messages.join(", ")}"
  end
end

puts "Création des familles"

# Créer 10 familles avec des données aléatoires depuis l'API randomuser
10.times do |i|
  # On prend un user depuis l'API random user pour chaque famille
  random_user = fetch_random_users(batch_size: 1).first

  # Les données de localisations sont reconstruites à partir de la réponse de l'API
  location = random_user['location']
  full_location = "#{location['street']['number']} #{location['street']['name']}, #{location['city']}, #{location['state']}, #{location['country']}"

  user = User.new(
    last_name: random_user['name']['last'],
    description: Faker::Lorem.sentence(word_count: 15),
    nationality: random_user['nat'],
    location: full_location,
    number_of_children: rand(1..5),  # Nombre d'enfants généré avec Faker
    role: "family",
    email: random_user['email'],
    password: "password"
  )

  if user.save
    puts "#{user.last_name} - Famille #{i + 1} créée avec succès!"
  else
    puts "Erreur lors de la création de la famille #{i + 1}: #{user.errors.full_messages.join(", ")}"
  end
end

puts "Création terminée !"
