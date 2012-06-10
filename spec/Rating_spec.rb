require 'spec_helper'
require 'pp'
include TrueSkill
describe Rating do
  it "Makes a Rating" do
    rate=Rating.new 
    rate.mu.should eql 25.0
    rate.sigma.should eql 25.0/3.0
  end
  it "Tests making a Factor group" do
    count=2
    team1=[]
    count.times do
      team1 << Rating.new
    end
    team2=[]
    1.times do
      team2 << Rating.new
    end
    TrueSkillObject.build_factor_graph([team1,team2],[0,1])
  end

end