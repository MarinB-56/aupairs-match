# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

LANGUAGES = File.readlines(Rails.root.join('db/languages.txt')).map(&:strip)

LANGUAGES.each do |language|
  Language.find_or_create_by(language: language)
end

require 'faker'

ROLES = User.roles.keys

NATIONALITIES = ['French', 'German', 'American', 'Spanish', 'Italian', 'Canadian', 'Australian']

100.times do
  role = ROLES.sample

  if role == 'family'
    User.create!(
      last_name: Faker::Name.last_name,
      description: Faker::Lorem.paragraph,
      nationality: NATIONALITIES.sample,
      location: Faker::Address.full_address,
      number_of_children: rand(0..5),
      role: role
    )
  else
    user = User.create!(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      birth_date: Faker::Date.between(from: '1980-01-01', to: '2005-12-31'),
      description: Faker::Lorem.paragraph,
      nationality: NATIONALITIES.sample,
      gender: ['Male', 'Female', 'Other'].sample,
      location: Faker::Address.full_address,
      role: role
    )

    # Seed de la table availabilities
    rand(1..3).times do
      Availability.create!(
        start: Faker::Date.forward(days: 30),
        end: Faker::Date.forward(days: 365),
        user: user
      )
    end

    # Seed de la table languages et user_languages
    languages = Language.order('RANDOM()').limit(rand(1..3))
    languages.each do |language|
      UserLanguage.create!(user: user, language: language)
    end
  end
end
