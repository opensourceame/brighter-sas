# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

100.times do

  company = Company.new(
    name:     Faker::Company.name,
  )

  company.save(validate: false)

  address = Address.new(
    line_1:         Faker::Address.street_address,
    city:           Faker::Address.city,
    postal_code:    Faker::Address.zip_code,
    country:        Faker::Address.country,
    company_id:     company.id,
  )

  address.save(validate: false)

  user = User.new(
    first_name:      Faker::Name.first_name,
    last_name:       Faker::Name.last_name,
    email:           Faker::Internet.email,
    company_id:      company.id,
  )

  user.save(validate: false)


end

AdminUser.create!(email: 'admin@stivad.nl', password: 'admin', password_confirmation: 'admin')