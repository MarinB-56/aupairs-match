require 'faker'
require 'open-uri'
require 'net/http'
require 'json'

# On définit une fonction qui appelle l'API randomuser pour récupérer un lot d'utilisateurs
# def fetch_random_users(batch_size: 1000)
  # url = URI("https://randomuser.me/api/?nat=us,gb,fr,es,de&inc=gender,name,location,email,login,dob,nat,picture&results=#{batch_size}&noinfo")
  # response = Net::HTTP.get(url)
  # JSON.parse(response)['results']
# end

# On filtre les utilisateurs pour ne garder que ceux dans la tranche d'âge
# def filter_users_by_age(users, age_min: 18, age_max: 30)
  # users.select do |user|
    # age = user['dob']['age']
    # age >= age_min && age <= age_max
  # end
# end

puts "Nettoyage de la base de données..."
User.destroy_all
Language.destroy_all
Availability.destroy_all
UserLanguage.destroy_all

puts "Création des utilisateurs (au pairs et familles)..."

puts "Création des au pairs"

# Profils au pair à ajouter en dur
au_pairs = [
  {
    first_name: "Charlie",
    last_name: "H.",
    birth_date: Date.new(2003, 5, 12),
    nationality: "Canada",
    gender: "female",
    location: "Quebec, Canada",
    email: "charlie.h@example.com",
    password: "password",
    description: "Chère famille, Je m’appelle Charlie, et je serais ravie de rejoindre votre famille en tant qu’au pair. Originaire du Quebec, je suis passionnée par le travail avec les enfants et je possède une solide expérience en garde d’enfants en tant d’éducatrice à la petite enfance ici au Quebec je m’occupe de 8 enfants de 2 à 3 ans. Ce qui me motive dans le rôle d’au pair, c’est non seulement la possibilité de veiller au bien-être et au développement de vos enfants, mais aussi de contribuer à leur épanouissement à travers des moments ludiques et éducatifs. Je suis patiente, responsable et très à l’écoute des besoins des enfants. J’aimerais beaucoup perfectionner mon anglais. En tant qu’au pair, je m’engage à fournir un environnement sûr, attentionné et stimulant pour vos enfants, tout en assurant une communication claire et ouverte avec vous, afin de répondre au mieux à vos attentes. Je serais honorée de faire partie de votre famille et de contribuer à la vie de vos enfants de manière positive et enrichissante. J’espère avoir l’opportunité de discuter davantage de mes qualifications et de ce que je peux apporter à votre foyer. Dans l’attente de vous rencontrer, veuillez recevoir, chère famille, mes salutations les plus chaleureuses.",
    start_date: Date.new(2025, 1, 1),
    end_date: Date.new(2027, 1, 1),
    languages: ["English", "French"],
    photo_filename: "ap_f_1.jpeg"
  },
  {
    first_name: "Isabella",
    last_name: "L.",
    birth_date: Date.new(2002, 9, 15),
    nationality: "États-Unis",
    gender: "female",
    location: "Los Angeles, États-Unis",
    email: "isabella.l@example.com",
    password: "password",
    description: "My name is Bella and I am from Los Angeles, California in America. I have four years of experience in working with children of various ages and backgrounds. I love embracing new cultures and meeting wonderful people! I am very accommodating and determined to support your family.",
    start_date: Date.new(2024, 12, 1),
    end_date: Date.new(2025, 2, 1),
    languages: ["English", "Spanish"],
    photo_filename: "ap_f_2.jpeg"
  },
  {
    first_name: "Leticia",
    last_name: "B.",
    birth_date: Date.new(2002, 3, 28),
    nationality: "Brésil",
    gender: "female",
    location: "Rio de Janeiro, Brésil",
    email: "leticia.b@example.com",
    password: "password",
    description: "Salut chère famille! C'est un plaisir de me présenter à vous. Je m'appelle Leticia, mais vous pouvez m'appeler Let ou Lele. J'ai 21 ans et je vis avec ma famille bien-aimée dans l'État de Rio de Janeiro, au Brésil. J'étudie l'éducation physique à l'université et je me prépare également à devenir Au Pair, ce qui me remplit d'enthousiasme. Je recherche une famille accueillante qui puisse m'accueillir en tant que membre et me faire vivre une expérience enrichissante d'échange culturel. Merci d'avance de visiter mon profil. Salutations du Brésil, Lele. Note: the consulate in Brazil is already issuing the visa and I am available to travel and I already have the French A1 certificate.",
    start_date: Date.new(2025, 1, 1),
    end_date: Date.new(2026, 1, 1),
    languages: ["Portuguese", "French"],
    photo_filename: "ap_f_3.jpeg"
  },
  {
    first_name: "Nathaly",
    last_name: "R.",
    birth_date: Date.new(1999, 11, 11),
    nationality: "Italie",
    gender: "female",
    location: "Rome, Italie",
    email: "nathaly.r@example.com",
    password: "password",
    description: "I am a sweet, friendly and outgoing girl. I have worked with a lot of different groups of people, so I have a lot of experience with people and how to handle a lot of situations. I like to be in nature, and playing games and sports. I have wanted to work and live in another country for some years now, and I hope this will be the opportunity for me. If you choose me as your au pair, I promise I will put a smile to your everyday!",
    start_date: Date.new(2024, 10, 1),
    end_date: Date.new(2025, 4, 1),
    languages: ["Portuguese", "Italian", "English"],
    photo_filename: "ap_f_4.jpeg"
  },
  {
    first_name: "Mathilda",
    last_name: "G.",
    birth_date: Date.new(2005, 7, 4),
    nationality: "Allemagne",
    gender: "female",
    location: "Cologne, Allemagne",
    email: "mathilda.g@example.com",
    password: "password",
    description: "Chère famille d'accueil, Je m'appelle Mathilda, j'ai 18 ans et je viens de Cologne. Je suis très heureuse d'avoir l'opportunité de bientôt faire partie de votre famille et de vous aider au quotidien. J'aime beaucoup les enfants, et c'est toujours un plaisir pour moi de passer du temps avec eux, de jouer et de les accompagner dans leur développement. Je suis impatiente de découvrir votre culture et d'améliorer mon français. J'espère que nous passerons de merveilleux moments ensemble et que j'aurai l'occasion d'apprendre beaucoup de choses avec vous. Je vous envoie mes salutations chaleureuses depuis Cologne et à très bientôt !",
    start_date: Date.new(2025, 3, 1),
    end_date: Date.new(2025, 9, 1),
    languages: ["German", "English"],
    photo_filename: "ap_f_5.jpeg"
  },
  {
    first_name: "Tainá",
    last_name: "R.",
    birth_date: Date.new(1998, 2, 17),
    nationality: "Brésil",
    gender: "female",
    location: "São Paulo, Brésil",
    email: "taina.r@example.com",
    password: "password",
    description: "Dear future host family, my name is Tainá and I’m currently an au pair in the Netherlands. I’m originally from the city of São Paulo and I’m 26 years old. I’m getting ready for my second year as an au pair and looking for a family who can be part of this amazing experience with me. I'm happy to have you here on my profile!",
    start_date: Date.new(2025, 2, 1),
    end_date: Date.new(2026, 2, 1),
    languages: ["Portuguese", "English", "Dutch"],
    photo_filename: "ap_f_6.jpeg"
  },
  {
    first_name: "Vitor",
    last_name: "E.",
    birth_date: Date.new(1995, 11, 3),
    nationality: "Brésil",
    gender: "male",
    location: "São Paulo, Brésil",
    email: "vitor.e@example.com",
    password: "password",
    description: "Dear host family, I'm Vitor, I'm 28 years old and I have 5 siblings. I have a degree in social sciences and I currently work as a geography, history, philosophy and sociology teacher in the São Paulo state school system. This work has given me a wealth of experience in interacting with and supporting children and teenagers in their development. My teaching experience has helped me develop skills such as responsibility, organization, teamwork and the ability to adapt to different environments. I am a very patient, caring and dedicated person, and I believe that these qualities are essential when caring for children. I am very willing to help with daily routines, play and create learning moments with them. I'm also ready to help with other tasks related to childcare, such as preparing meals, helping with homework and making sure the child is safe.",
    start_date: Date.new(2024, 11, 1),
    end_date: Date.new(2026, 11, 1),
    languages: ["Portuguese", "English"],
    photo_filename: "ap_m_1.jpeg"
  }
  # Ajoute ici les autres au pairs avec leur description complète
]

# Création des au pairs
au_pairs.each_with_index do |au_pair_data, i|
  user = User.new(
    first_name: au_pair_data[:first_name],
    last_name: au_pair_data[:last_name],
    birth_date: au_pair_data[:birth_date],
    nationality: au_pair_data[:nationality],
    gender: au_pair_data[:gender],
    location: au_pair_data[:location],
    email: au_pair_data[:email],
    password: au_pair_data[:password],
    description: au_pair_data[:description],
    role: "aupair"
  )

  if user.save
    # Attacher une photo locale depuis le dossier aupairs_seeds
    user.photo.attach(io: File.open(Rails.root.join('app/assets/images/aupairs_seeds', au_pair_data[:photo_filename])), filename: au_pair_data[:photo_filename], content_type: 'image/jpeg')

    puts "#{user.first_name} #{user.last_name} - Au pair #{i + 1} créée avec succès!"

    # Ajouter les langues
    au_pair_data[:languages].each do |language|
      lang = Language.find_or_create_by!(language: language)
      UserLanguage.create!(user: user, language: lang)
    end

    # Ajouter les disponibilités
    Availability.create!(
      user: user,
      start: au_pair_data[:start_date],
      end: au_pair_data[:end_date]
    )
  else
    puts "Erreur lors de la création de l'au pair #{i + 1}: #{user.errors.full_messages.join(", ")}"
  end
end

puts "Création terminée !"

# Récupérer un lot d'utilisateurs depuis l'API
# random_users = fetch_random_users(batch_size: 1000)
# Filtrer les utilisateurs par tranche d'âge
# filtered_users = filter_users_by_age(random_users, age_min: 18, age_max: 30)

# Si moins de 10 utilisateurs dans la tranche d'âge, afficher un message
# if filtered_users.size < 10
  # puts "Attention : Moins de 10 utilisateurs disponibles dans la tranche d'âge sélectionnée."
# end

# Créer 10 au pairs avec les utilisateurs filtrés
# filtered_users.first(10).each_with_index do |random_user, i|
  # Les données de localisations sont reconstruites à partir de la réponse de l'API
  # location = random_user['location']
  # full_location = "#{location['street']['number']} #{location['street']['name']}, #{location['city']}, #{location['state']}, #{location['country']}"

  # Parse la date d'anniversaire pour nous assurer que le format est correct
  # birth_date = Date.parse(random_user['dob']['date'])

  # user = User.new(
    # first_name: random_user['name']['first'],
    # last_name: random_user['name']['last'],
    # birth_date: birth_date,
    # description: Faker::Lorem.sentence(word_count: 15),
    # nationality: random_user['nat'],
    # gender: random_user['gender'],
    # location: full_location,
    # role: "aupair",
    # email: random_user['email'],
    # password: "password"
  #)

  # if user.save
    # Attacher une photo depuis l'API randomuser
    # user.photo.attach(io: URI.open(random_user['picture']['large']), filename: "aupair_#{i + 1}.jpg", content_type: 'image/jpeg')
    # puts "#{user.first_name} #{user.last_name} - Au pair #{i + 1} créée avec succès!"

    # Ajout des langues pour chaque au pair
    # languages = ['English', 'Spanish', 'French', 'German', 'Italian'].sample(rand(1..3))
    # languages.each do |language|
      # lang = Language.find_or_create_by!(language: language)
      # UserLanguage.create!(user: user, language: lang)
    # end

    # Ajout des disponibilités pour chaque au pair
    # Availability.create!(
      # user: user,
      # start: Faker::Date.between(from: Date.today, to: 1.month.from_now),
      # end: Faker::Date.between(from: 2.months.from_now, to: 6.months.from_now)
    # )
  # else
    # puts "Erreur lors de la création de l'au pair #{i + 1}: #{user.errors.full_messages.join(", ")}"
  # end
# end

puts "Création des familles"

# Créer 10 familles avec des données aléatoires depuis l'API randomuser
# 10.times do |i|
  # On prend un user depuis l'API random user pour chaque famille
  # random_user = fetch_random_users(batch_size: 1).first

  # Les données de localisations sont reconstruites à partir de la réponse de l'API
  # location = random_user['location']
  # full_location = "#{location['street']['number']} #{location['street']['name']}, #{location['city']}, #{location['state']}, #{location['country']}"

  # user = User.new(
    # last_name: random_user['name']['last'],
    # description: Faker::Lorem.sentence(word_count: 15),
    # nationality: random_user['nat'],
    # location: full_location,
    # number_of_children: rand(1..5),  # Nombre d'enfants généré avec Faker
    # role: "family",
    # email: random_user['email'],
    # password: "password"
  #)

  # if user.save
    # puts "#{user.last_name} - Famille #{i + 1} créée avec succès!"
  # else
    # puts "Erreur lors de la création de la famille #{i + 1}: #{user.errors.full_messages.join(", ")}"
  # end
# end

# Génération de 10 familles avec Faker
10.times do |i|
  family = User.new(
    last_name: Faker::Name.last_name,
    location: "#{Faker::Address.city}, #{Faker::Address.country}",
    email: Faker::Internet.email,
    password: "password",
    description: "Nous sommes une famille à la recherche d'une au pair pour aider avec nos enfants.",
    role: "family",
    number_of_children: rand(1..4) # Génère un nombre aléatoire d'enfants
  )

  if family.save
    # Générer des photos pour les familles via Faker (ou utiliser des images locales si nécessaire)
    family.photo.attach(io: File.open(Rails.root.join("app/assets/images/families_seeds/family_#{i + 1}.jpeg")), filename: "family_#{i + 1}.jpeg", content_type: 'image/jpeg')

    puts "Famille #{family.last_name} créée avec succès !"
  else
    puts "Erreur lors de la création de la famille #{i + 1}: #{family.errors.full_messages.join(", ")}"
  end
end


puts "Création terminée !"
