namespace :dummy_data do
  desc "Generate dummy data."
  task :generate => :environment do
    User.all.each_with_index do |user, index|
      
      if user.admin? 
        puts "--- admin #{index+1}"
        user.email = "admin#{index+1}@example.com"
        user.username = "admin#{index+1}"
        user.first_name = "admin#{index+1}"
        user.last_name = ""
        user.password = 'testing'
        user.skip_confirmation!
        user.save!
      else
        puts "--- student #{index+1}"
        user.email = "student#{index+1}@example.com"
        user.username = "student#{index+1}"
        user.first_name = "student#{index+1}"
        user.last_name = ""
        user.password = 'testing'
        user.skip_confirmation!
        user.save!
      end
    end
  end

  desc "Print users"
  task :print => :environment do
    puts "Username - Email - Password"
    puts "---------------------------------------"
    User.all.each do |user|
      puts "#{user.username} - #{user.email} - testing"
    end
  end
end


