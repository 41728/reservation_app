User.find_or_create_by!(email: "admin@kannri.com") do |user|
  user.password = "123abc"
  user.password_confirmation = "123abc"
  user.admin = true
end