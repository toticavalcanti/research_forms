FactoryGirl.define do
    timestamp = loop do
       date = FFaker::Time.date.to_time
       break date.strftime("%F %T") if date &lt;= Date.today
    end
  
  
  factory :user do
    uid          { FFaker::Lorem.word }
    email        { FFaker::Internet.email }
    name         { FFaker::Name.name }
    nickname     { FFaker::Internet.user_name }
    password     { FFaker::Lorem.word }
    provider     'email'
    confirmed_at timestamp
    created_at   timestamp
    updated_at   timestamp
  end
 end