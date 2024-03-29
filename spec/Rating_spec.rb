# frozen_string_literal: true

require 'spec_helper'
require 'pp'

describe Rating do
  it 'Makes a Rating' do
    rate = Rating.new
    rate.mu.should eql 25.0
    rate.sigma.should eql 25.0 / 3.0
  end
  it 'Tests a 1 vs 1 match With player 1 winning' do
    team1 = []
    team1 << Rating.new
    team2 = []
    team2 << Rating.new
    result = g.transform_ratings([team1, team2], [0, 1])

    result[0][0].mu.should be_within(0.0001).of 29.39583169299151
    result[1][0].mu.should be_within(0.0001).of 20.604168307008482

    result[0][0].sigma.should be_within(0.0001).of 7.17147580700922
    result[1][0].sigma.should be_within(0.0001).of 7.17147580700922
    # pp trunc_layer
  end
  it 'Tests a 1 vs 1 match With player 1 winning With non default rating' do
    team1 = []
    team1 << Rating.new(10.0, 3.33333)
    team2 = []
    team2 << Rating.new
    result = g.transform_ratings([team1, team2], [0, 1])
    result[0][0].mu.should eql 11.97746732148216
    result[1][0].mu.should eql 12.647289062586932

    result[0][0].sigma.should eql 3.1951972740346792
    result[1][0].sigma.should eql 5.8301397396829335
    # pp trunc_layer
  end
  it 'Tests a 1 vs 1 match With player 2 winning' do
    team1 = []
    team1 << Rating.new
    team2 = []
    team2 << Rating.new
    result = g.transform_ratings([team1, team2], [1, 0])

    result[1][0].mu.should be_within(0.0001).of 29.39583169299151
    result[0][0].mu.should be_within(0.0001).of 20.604168307008482

    result[1][0].sigma.should be_within(0.0001).of 7.17147580700922
    result[0][0].sigma.should be_within(0.0001).of 7.17147580700922
  end

  it 'Tests a 1 vs 1 match With player 2 winning' do
    team1 = []
    team1 << Rating.new
    team2 = []
    team2 << Rating.new
    result = g.transform_ratings([team1, team2], [1, 0])

    result[1][0].mu.should be_within(0.0001).of 29.39583169299151
    result[0][0].mu.should be_within(0.0001).of 20.604168307008482

    result[1][0].sigma.should be_within(0.0001).of 7.17147580700922
    result[0][0].sigma.should be_within(0.0001).of 7.17147580700922
  end
  it 'Tests a 3 player match With player 1 winning, player 2 2nd, player 3 3rd' do
    team1 = []
    team1 << Rating.new(10.0, 3.33333)
    team2 = []
    team2 << Rating.new
    team3 = []
    team3 << Rating.new
    result = g.transform_ratings([team1, team2, team3], [0, 1, 2])
    # pp result
    result[0][0].mu.should be_within(0.0001).of 13.940888199346766
    result[1][0].mu.should be_within(0.0001).of 11.685764379823087
    result[2][0].mu.should be_within(0.0001).of 9.337982888632599

    result[0][0].sigma.should be_within(0.0001).of 3.148556927632652
    result[1][0].sigma.should be_within(0.0001).of 6.735388289049392
    result[2][0].sigma.should be_within(0.0001).of 5.494893620335039
    # pp trunc_layer
  end
  it 'Tests a 1 vs 1 match Match quality' do
    team1 = []
    team1 << Rating.new
    team2 = []
    team2 << Rating.new
    pp g.match_quality([[team1], [team2]])
  end
end
