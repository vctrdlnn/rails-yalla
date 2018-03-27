require 'Faker'

[1.100].each do |x|
  nom = Faker::DragonBall.character
  p nom
end
