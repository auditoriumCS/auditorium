namespace :dummy_data do
  desc "Generate dummy data."
  task :generate => :environment do
    User.all.each_with_index do |user, index|
      puts "--- user #{index+1}"
      
      user.email = "user#{index+1}@example.com"
      user.username = "user#{index+1}"
      user.first_name = "user#{index+1}"
      user.last_name = "test"
      user.password = 'testing'
      user.skip_confirmation!
      user.save!
    end
  end
end


