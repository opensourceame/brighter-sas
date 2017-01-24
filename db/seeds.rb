# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


class String
  def to_class
    self.split('::').inject(Object) do |mod, class_name|
      mod.const_get(class_name)
    end
  end
end

SEED_START_ID = 100

('a'..'e').to_a.each do |letter|

  plan = Plan.create(
    name:           "plan_#{letter}",
    description:    "This is PLAN #{letter.upcase}"
  )

  plan.save(validate: false)

end

yaml = YAML.load_file('db/seeds.yaml')

yaml.each do |type, objects|

  objects.each do |data|
    o = type.to_class.new(data)
    o.save(validate: false)
  end

end

SEED_START_ID.times do |n|

  company = Company.new(
    id:             n + SEED_START_ID,
    name:           Faker::Company.name,
  )

  company.save(validate: false)

  address = Address.new(
    id:             n + SEED_START_ID,
    line_1:         Faker::Address.street_address,
    city:           Faker::Address.city,
    postal_code:    Faker::Address.zip_code,
    country_code:   Faker::Address.country_code,
    company_id:     company.id,
  )

  address.save(validate: false)

  user = User.new(
    id:             n + SEED_START_ID,
    first_name:     Faker::Name.first_name,
    last_name:      Faker::Name.last_name,
    email:          Faker::Internet.email,
    company_id:     company.id,
  )

  user.save(validate: false)


end

