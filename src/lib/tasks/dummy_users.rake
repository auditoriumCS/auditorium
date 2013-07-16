namespace :dummy_data do
  desc "Generate dummy data."
  task :generate => :environment do
    User.where(admin: true).each_with_index do |user, index|
      puts "--- admin #{index+1}"
      user.email = "admin#{index+1}@tu-dresden.de"
      user.username = "admin-#{index+1}"
      user.first_name = "admin#{index+1}"
      user.last_name = ""
      user.password = 'testing'
      user.skip_confirmation!
      user.save!
    end
    User.where(admin: false).each_with_index do |user, index|
      puts "--- student #{index+1}"
      user.email = "student#{index+1}@tu-dresden.de"
      user.username = "student-#{index+1}"
      user.first_name = "student #{index+1}"
      user.last_name = ""
      user.password = 'testing'
      user.skip_confirmation!
      user.save!
    end
  end

  desc "Print users"
  task :print => :environment do
    puts "Username - Email - Password"
    puts "---------------------------------------"
    User.order(:email).each do |user|
      puts "#{user.email} - testing"
    end
  end
end


