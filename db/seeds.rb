require "faker"

AdminUser.find_or_create_by!(email: "admin@pegcitycoffee.ca") do |admin|
  admin.password = "password123"
  admin.password_confirmation = "password123"
end

provinces_data = [
  { name: "Alberta", code: "AB", gst_rate: 0.05, pst_rate: 0.00, hst_rate: 0.00 },
  { name: "British Columbia", code: "BC", gst_rate: 0.05, pst_rate: 0.07, hst_rate: 0.00 },
  { name: "Manitoba", code: "MB", gst_rate: 0.05, pst_rate: 0.07, hst_rate: 0.00 },
  { name: "New Brunswick", code: "NB", gst_rate: 0.00, pst_rate: 0.00, hst_rate: 0.15 },
  { name: "Newfoundland and Labrador", code: "NL", gst_rate: 0.00, pst_rate: 0.00, hst_rate: 0.15 },
  { name: "Northwest Territories", code: "NT", gst_rate: 0.05, pst_rate: 0.00, hst_rate: 0.00 },
  { name: "Nova Scotia", code: "NS", gst_rate: 0.00, pst_rate: 0.00, hst_rate: 0.15 },
  { name: "Nunavut", code: "NU", gst_rate: 0.05, pst_rate: 0.00, hst_rate: 0.00 },
  { name: "Ontario", code: "ON", gst_rate: 0.00, pst_rate: 0.00, hst_rate: 0.13 },
  { name: "Prince Edward Island", code: "PE", gst_rate: 0.00, pst_rate: 0.00, hst_rate: 0.15 },
  { name: "Quebec", code: "QC", gst_rate: 0.05, pst_rate: 0.09975, hst_rate: 0.00 },
  { name: "Saskatchewan", code: "SK", gst_rate: 0.05, pst_rate: 0.06, hst_rate: 0.00 },
  { name: "Yukon", code: "YT", gst_rate: 0.05, pst_rate: 0.00, hst_rate: 0.00 }
]

provinces_data.each do |attrs|
  Province.find_or_initialize_by(code: attrs[:code]).update!(attrs)
end

categories = [
  Category.find_or_create_by!(name: "Single Origin") { |c| c.description = "Traceable micro-lot specialty coffee beans." },
  Category.find_or_create_by!(name: "Espresso Blends") { |c| c.description = "Balanced blends roasted in Winnipeg for rich crema." },
  Category.find_or_create_by!(name: "Decaf & Half-Caf") { |c| c.description = "Swiss Water Process decaffeinated coffee beans." },
  Category.find_or_create_by!(name: "Brewing Gear & Merch") { |c| c.description = "Pour-over drippers, grinders, and mugs." }
]

if Product.count < 104
  (104 - Product.count).times do |i|
    cat = categories[i % categories.length]
    Product.create!(
      title: "#{Faker::Coffee.origin} #{Faker::Coffee.blend_name}",
      description: "Small-batch roasted in Winnipeg by Peg City Coffee Roasters. Notes: #{Faker::Coffee.notes}.",
      price: rand(16.50..38.00).round(2),
      stock_quantity: rand(5..50),
      category: cat
    )
  end
end

puts "Seeded #{Province.count} provinces, #{Category.count} categories, and #{Product.count} products."
