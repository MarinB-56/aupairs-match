require 'faker'
require 'open-uri'
require 'net/http'
require 'json'

puts "Nettoyage de la base de données..."
puts "Nettoyage des users..."
User.destroy_all
puts "Nettoyage des Languages..."
Language.destroy_all
# Availability.destroy_all => Pas nécessaire (les User étant supprimés, les Availabilities le seront aussi)
# UserLanguage.destroy_all => Pas nécessaire (les User étant supprimés, les userLanguage le seront aussi)

puts "Création des utilisateurs (au pairs et familles)..."

puts "Création des au pairs"

# Profils au pair à ajouter en dur
au_pairs = [
  {
    first_name: "Charlie",
    last_name: "H.",
    birth_date: Date.new(2003, 5, 12),
    nationality: "Canadian",
    gender: "female",
    location: "Quebec, Canada",
    email: "charlie.h@example.com",
    password: "password",
    description: "Dear family, My name is Charlie, and I would be delighted to join your family as an au pair. Originally from Quebec, I am passionate about working with children, and I have solid experience in childcare as a preschool educator here in Quebec. I take care of 8 children aged 2 to 3 years old. What motivates me in the role of au pair is not only the opportunity to care for and support your children but also to contribute to their development through fun and educational activities. I am patient, responsible, and very attentive to children's needs. I would love to improve my English. As an au pair, I commit to providing a safe, caring, and stimulating environment for your children while maintaining clear and open communication with you to meet your expectations. I would be honored to be part of your family and positively contribute to your children's lives. I look forward to discussing my qualifications further and what I can bring to your household. Until we meet, warm regards.",
    start_date: Date.new(2025, 1, 1),
    end_date: Date.new(2027, 1, 1),
    languages: ["English", "French"],
    photo_filename: "ap_f_1.jpeg"
  },
  {
    first_name: "Isabella",
    last_name: "L.",
    birth_date: Date.new(2002, 9, 15),
    nationality: "American",
    gender: "female",
    location: "Los Angeles, United States",
    email: "isabella.l@example.com",
    password: "password",
    description: "My name is Bella and I am from Los Angeles, California, in the USA. I have four years of experience working with children of various ages and backgrounds. I love embracing new cultures and meeting wonderful people! I am very accommodating and determined to support your family.",
    start_date: Date.new(2024, 12, 1),
    end_date: Date.new(2025, 2, 1),
    languages: ["English", "Spanish"],
    photo_filename: "ap_f_2.jpeg"
  },
  {
    first_name: "Leticia",
    last_name: "B.",
    birth_date: Date.new(2002, 3, 28),
    nationality: "Brazilian",
    gender: "female",
    location: "Rio de Janeiro, Brazil",
    email: "leticia.b@example.com",
    password: "password",
    description: "Hi dear family! It is a pleasure to introduce myself to you. My name is Leticia, but you can call me Let or Lele. I am 21 years old, and I live with my beloved family in the state of Rio de Janeiro, Brazil. I study physical education at university and am also preparing to become an Au Pair, which fills me with excitement. I am looking for a welcoming family that can embrace me as a member and provide a rich cultural exchange experience. Thank you in advance for visiting my profile. Greetings from Brazil, Lele. Note: The consulate in Brazil is already issuing the visa, and I am available to travel. I already have the French A1 certificate.",
    start_date: Date.new(2025, 1, 1),
    end_date: Date.new(2026, 1, 1),
    languages: ["Portuguese", "French"],
    photo_filename: "ap_f_3.jpeg"
  },
  {
    first_name: "Nathaly",
    last_name: "R.",
    birth_date: Date.new(1999, 11, 11),
    nationality: "Italian",
    gender: "female",
    location: "Rome, Italy",
    email: "nathaly.r@example.com",
    password: "password",
    description: "I am a sweet, friendly, and outgoing girl. I have worked with many different groups of people, so I have a lot of experience with handling various situations. I enjoy being in nature, playing games, and sports. I've wanted to work and live in another country for years now, and I hope this will be the opportunity for me. If you choose me as your au pair, I promise to bring a smile to your everyday life!",
    start_date: Date.new(2024, 10, 1),
    end_date: Date.new(2025, 4, 1),
    languages: ["Portuguese", "Italian", "English"],
    photo_filename: "ap_f_4.jpeg"
  },
  {
    first_name: "Mathilda",
    last_name: "G.",
    birth_date: Date.new(2005, 7, 4),
    nationality: "German",
    gender: "female",
    location: "Cologne, Germany",
    email: "mathilda.g@example.com",
    password: "password",
    description: "Dear host family, My name is Mathilda, I am 18 years old, and I am from Cologne. I am very excited about the opportunity to soon become part of your family and help you with your daily tasks. I love children, and it is always a pleasure for me to spend time with them, play, and support their development. I am eager to discover your culture and improve my French. I hope we will have wonderful moments together, and I will have the opportunity to learn a lot with you. I send my warmest greetings from Cologne, and see you soon!",
    start_date: Date.new(2025, 3, 1),
    end_date: Date.new(2025, 9, 1),
    languages: ["German", "English"],
    photo_filename: "ap_f_5.jpeg"
  },
  {
    first_name: "Tainá",
    last_name: "R.",
    birth_date: Date.new(1998, 2, 17),
    nationality: "Brazilian",
    gender: "female",
    location: "São Paulo, Brazil",
    email: "taina.r@example.com",
    password: "password",
    description: "Dear future host family, my name is Tainá and I’m currently an au pair in the Netherlands. I’m originally from the city of São Paulo, and I’m 26 years old. I’m getting ready for my second year as an au pair and looking for a family who can be part of this amazing experience with me. I'm happy to have you here on my profile!",
    start_date: Date.new(2025, 2, 1),
    end_date: Date.new(2026, 2, 1),
    languages: ["Portuguese", "English", "Dutch"],
    photo_filename: "ap_f_6.jpeg"
  },
  {
    first_name: "Grace",
    last_name: "R.",
    birth_date: Date.new(2002, 2, 14),
    nationality: "American",
    gender: "female",
    location: "New York, United States",
    email: "grace.r@example.com",
    password: "password",
    description: "Hi there! I’m Grace, a 22-year-old from the United States who just graduated from college. In school, I studied international relations, so I am very passionate about travel and learning about new cultures and lifestyles.",
    start_date: Date.new(2025, 1, 1),
    end_date: Date.new(2026, 6, 1),
    languages: ["English", "French"],
    photo_filename: "ap_f_7.jpeg"
  },
  {
    first_name: "Lily",
    last_name: "T.",
    birth_date: Date.new(2003, 12, 10),
    nationality: "American",
    gender: "female",
    location: "Auckland, New Zealand",
    email: "lily.t@example.com",
    password: "password",
    description: "Kia Ora! I'm Lily, New Zealand born and raised with dual American citizenship. I'm excited to expand my horizons while doing what I love most: caring for children. I look forward to meeting your family and getting to know your little ones!",
    start_date: Date.new(2025, 2, 1),
    end_date: Date.new(2027, 2, 1),
    languages: ["English", "Maori"],
    photo_filename: "ap_f_8.jpeg"
  },
  {
    first_name: "Irene",
    last_name: "A.",
    birth_date: Date.new(2000, 6, 25),
    nationality: "Spanish",
    gender: "female",
    location: "Barcelona, Spain",
    email: "irene.a@example.com",
    password: "password",
    description: "Dear Host Family, My name is Irene, I am 24 years old, and I live in Barcelona. I have completed my studies in International Trade and am currently training to become a flight attendant. I have been taking care of my siblings, aged 13 and 17 years old, since they were born. Over the years, I have helped with their homework, organized activities, and ensured they always feel supported. With my younger brother, I engage in creative and educational activities, while with my older brother, I provide guidance on important decisions about his studies and future. These experiences have taught me patience, responsibility, and strong communication skills. I believe these qualities will be valuable as an au pair, and I am confident I can use them to create a positive and supportive environment for your family.",
    start_date: Date.new(2025, 1, 1),
    end_date: Date.new(2026, 1, 1),
    languages: ["Spanish", "English"],
    photo_filename: "ap_f_9.jpeg"
  },
  {
    first_name: "Carmen",
    last_name: "S.",
    birth_date: Date.new(2001, 10, 20),
    nationality: "Spanish",
    gender: "female",
    location: "Madrid, Spain",
    email: "carmen.s@example.com",
    password: "password",
    description: "Hola, soy Carmen. I'm from Madrid, Spain, and I've worked with children in various settings, from schools to summer camps. I love nurturing children's creativity and seeing them grow into their best selves. I am excited to work with a family that shares similar values.",
    start_date: Date.new(2025, 2, 1),
    end_date: Date.new(2026, 12, 1),
    languages: ["Spanish", "English"],
    photo_filename: "ap_f_10.jpeg"
  },
  {
    first_name: "Vitor",
    last_name: "E.",
    birth_date: Date.new(1995, 11, 3),
    nationality: "Brazilian",
    gender: "male",
    location: "São Paulo, Brazil",
    email: "vitor.e@example.com",
    password: "password",
    description: "Dear host family, I'm Vitor, I'm 28 years old and I have 5 siblings. I have a degree in social sciences and I currently work as a geography, history, philosophy, and sociology teacher in the São Paulo state school system. This work has given me a wealth of experience in interacting with and supporting children and teenagers in their development. My teaching experience has helped me develop skills such as responsibility, organization, teamwork, and the ability to adapt to different environments. I am a very patient, caring, and dedicated person, and I believe that these qualities are essential when caring for children. I am very willing to help with daily routines, play, and create learning moments with them. I'm also ready to help with other tasks related to childcare, such as preparing meals, helping with homework, and making sure the child is safe.",
    start_date: Date.new(2024, 11, 1),
    end_date: Date.new(2026, 11, 1),
    languages: ["Portuguese", "English"],
    photo_filename: "ap_m_1.jpeg"
  },
  {
    first_name: "Damien",
    last_name: "O.",
    birth_date: Date.new(2003, 8, 23),
    nationality: "American",
    gender: "male",
    location: "San Diego, United States",
    email: "damien.o@example.com",
    password: "password",
    description: "Hello, my name is Damien. I am 21 years old, and a Business student in Southern California. I'm from the United States, specifically San Diego, California. I want to become an Au pair or Nanny as I enjoy learning about new people every day. I have experience caring for my younger brothers, and recently took care of two 5-year-olds for about a year. I studied in London at the start of 2024 and loved being abroad. I enjoyed exploring the city, trying new food, activities, and being surrounded by people from all backgrounds. I consider myself a good fit because I have experience with younger children. I know patience is crucial, and every child is different. Catering to each child's needs and the parents' requirements is important.",
    start_date: Date.new(2024, 7, 1),
    end_date: Date.new(2025, 12, 1),
    languages: ["English", "Spanish"],
    photo_filename: "ap_m_2.jpeg"
  }
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

puts "Création des familles"

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

# Génération d'un compte famille pour se logger manuellement

admin_family = User.new(
  last_name: 'Admin',
  location: "#{Faker::Address.city}, #{Faker::Address.country}",
  email: 'family@example.com',
  password: "password",
  description: "Nous ne sommes pas famille, ce compte n'existe que pour permettre de nous logger sur AupairMatch.",
  role: "family",
  number_of_children: rand(1..4)
)

if admin_family.save
  # Générer des photos pour les familles via Faker (ou utiliser des images locales si nécessaire)
  admin_family.photo.attach(io: File.open(Rails.root.join("app/assets/images/families_seeds/admin_family.jpeg")), filename: "admin_family.jpeg", content_type: 'image/jpeg')

  puts "Famille Admin créée avec succès !"
else
  puts "Erreur lors de la création de la famille Admin: #{family.errors.full_messages.join(", ")}"
end

puts "Création terminée !"
