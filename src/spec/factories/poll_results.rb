# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :poll_result do
    userId 1
    questionId 1
    choiceId 1
  end
end
