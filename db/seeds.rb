require 'csv'

file = File.read('db/seeds/users.csv')
CSV.parse(file, headers: true).each do |row|
  User.create(row.to_h)
end
