require 'csv'

%w(user rating).each do |name|
  file = File.read("db/seeds/#{name.pluralize}.csv")
  CSV.parse(file, headers: true).each do |row|
    model = name.titleize.constantize
    model.delete_all
    model.create(row.to_h)
  end
end
