# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :location do
    name "MyString"
    area1 "MyString"
    area2 "MyString"
    caretype "MyString"
    streetaddress "MyString"
    streetnumber "MyString"
    pobox "MyString"
    zipcode "MyString"
    ziparea "MyString"
    city "MyString"
    phone "MyString"
    email "MyString"
    supervisor "MyString"
    supervisoremail "MyString"
    supervisorphone "MyString"
    capacity 1
  end
end
