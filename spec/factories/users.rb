FactoryBot.define do
  factory :user do
    name {'Fake Name'}
    address {'1234 Fake Ln.'}
    city {'Unknown'}
    state {'AA'}
    zip {00000}
    email {'jane@unknown.com'}
    password {'password'}
    role {0}
  end

  factory :random_user, class: User do
    name {'Fake Name'}
    address {'1234 Fake Ln.'}
    city {'City of Unknown'}
    state {'AA'}
    zip {00000}
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    role {0}
  end
end