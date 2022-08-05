require 'csv'

%w(user post comment rating).each do |name|
  file = File.read("db/seeds/#{name.pluralize}.csv")
  model = name.titleize.constantize
  model.delete_all

  CSV.parse(file, headers: true, liberal_parsing: true).each do |row|
    model.create(row.to_h.except('created_at', 'updated_at'))
  end
end
