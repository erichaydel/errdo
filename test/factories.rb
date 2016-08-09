FactoryGirl.define do
  factory :error, class: "Errdo::Error" do
    exception_class_name      "RuntimeError"
    exception_message         "standard-error"
    sequence(:backtrace)      { |n| ["error#{n}"] }
    http_method               "GET"
    host_name                 "www.example.com"
    url                       "www.example.com"
  end

  factory :error_occurrence, class: "Errdo::ErrorOccurrence" do
  end
end
