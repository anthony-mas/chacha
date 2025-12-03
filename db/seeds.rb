puts "Creating default event categories..."
CATEGORIES = [
  "Art & Culture",
  "Sport",
  "Social",
  "Networking",
  "Hobbies"
]

CATEGORIES.each do |category_name|
  Category.find_or_create_by!(name: category_name)
end
puts "Categories created successfully!"
