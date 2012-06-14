require 'spec_helper'
require 'pp'

describe Rating do
  it "Makes a Rating" do
    rate=Rating.new 
    rate.mu.should eql 25.0
    rate.sigma.should eql 25.0/3.0
  end
  it "Tests a 1 vs 1 match With player 1 winning" do
    team1=[]
    1.times do
      team1 << Rating.new
    end
    team2=[]
    1.times do
      team2 << Rating.new
    end
    result=g().transform_ratings([team1,team2],[0,1])
    
    result[0][0].mu.should eql 29.39583169299151
    result[1][0].mu.should eql 20.604168307008482
    
    result[0][0].sigma.should eql 7.17147580700922
    result[1][0].sigma.should eql 7.17147580700922
    #pp trunc_layer
  end
  it "Tests a 1 vs 1 match With player 1 winning With non default rating" do
    team1=[]
    1.times do
      team1 << Rating.new(10.0,3.33333)
    end
    team2=[]
    1.times do
      team2 << Rating.new
    end
    result=g().transform_ratings([team1,team2],[0,1])
    result[0][0].mu.should eql 11.97746732148216
    result[1][0].mu.should eql 12.647289062586932
    
    result[0][0].sigma.should eql 3.1951972740346792
    result[1][0].sigma.should eql 5.8301397396829335
    #pp trunc_layer
  end
  it "Tests a 1 vs 1 match With player 2 winning" do
    team1=[]
    1.times do
      team1 << Rating.new
    end
    team2=[]
    1.times do
      team2 << Rating.new
    end
    result=g().transform_ratings([team1,team2],[1,0])
    
    result[1][0].mu.should eql 29.39583169299151
    result[0][0].mu.should eql 20.604168307008482
    
    result[1][0].sigma.should eql 7.17147580700922
    result[0][0].sigma.should eql 7.17147580700922
  end
  #it "Tests a 1 vs 1 match Match quality" do
  #  team1=[]
  #  1.times do
  #    team1 << Rating.new
  #  end
  #  team2=[]
  #  1.times do
  #    team2 << Rating.new
  #  end
  #  g().match_quality([team1,team2])
  #end
end