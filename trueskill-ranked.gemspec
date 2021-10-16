Gem::Specification.new do |s|
  s.name        = 'trueskill-ranked'
  s.version     = '2.1'
  s.date        = '2012-06-13'
  s.summary     = "Ranked TrueSkill"
  s.description = "A improved TrueSkill with correct ranking order Now with Match Quality also fixed error with missing matrix"
  s.authors     = ["Katrina Knight","Heungsub Lee"]
  s.email       = 'kat.knight@nekokittygames.com'
  s.files       = ["lib/TrueSkill.rb","lib/TrueSkill/Array.rb","lib/TrueSkill/core_ext.rb","lib/TrueSkill/Rating.rb","lib/TrueSkill/general.rb","lib/TrueSkill/TrueSkill.rb","lib/TrueSkill/FactorGraph/Factor.rb","lib/TrueSkill/FactorGraph/LikelihoodFactor.rb","lib/TrueSkill/FactorGraph/PriorFactor.rb","lib/TrueSkill/FactorGraph/SumFactor.rb","lib/TrueSkill/FactorGraph/TruncateFactor.rb","lib/TrueSkill/FactorGraph/Variable.rb","lib/TrueSkill/Mathematics/general.rb","lib/TrueSkill/Mathematics/guassian.rb","lib/TrueSkill/Mathematics/matrix.rb"]
  s.homepage    =
    'https://github.com/KatrinaAS/trueskill-ranked'
end