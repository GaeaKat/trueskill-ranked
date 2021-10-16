# -*- encoding : utf-8 -*-
require 'pp'

%w(
  general
  guassian
  matrix
).each do |name|
  require File.expand_path(File.join(File.dirname(__FILE__), "TrueSkill", "Mathematics", "#{name}.rb"))
end

%w(
  Factor
  LikelihoodFactor
  PriorFactor
  SumFactor
  TruncateFactor
  Variable
).each do |name|
  require File.expand_path(File.join(File.dirname(__FILE__), "TrueSkill", "FactorGraph", "#{name}.rb"))
end

%w(
  Array
  core_ext
  general
  Rating
  TrueSkill
).each do |name|
  require File.expand_path(File.join(File.dirname(__FILE__), "TrueSkill", "#{name}.rb"))
end