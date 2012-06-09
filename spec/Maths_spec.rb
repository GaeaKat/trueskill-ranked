require 'spec_helper'
require 'pp'
include TrueSkill
describe "General" do
 it "Correctly uses ierfcc" do
  @val=ierfcc(Math.erfc(1.5))
  @val.should eql 1.5
 end
 
 it "Correctly uses cdf" do
  @val=cdf(1)
  #pp @val
 end
  it "Correctly uses ppf" do
    @val=ppf(cdf(1.5))
    @val.should eql 1.5
  end
end

describe Gaussian do

  it "makes a new Gaussian" do
    @gauss=Gaussian.new 1.5,2.0
    @gauss.mu.should eql 1.5
    @gauss.sigma.should eql 2.0
  end
  it "Multiplies a  Gaussian" do
    @gauss=Gaussian.new 1.5,2.0
    @gauss2=Gaussian.new 3,4
    @gauss3=@gauss*@gauss2
    #pp @gauss3.mu
    #pp @gauss3.sigma
    @gauss3.mu.should eql 1.8
    @gauss3.sigma.should eql 1.7888543819998317
  end
  # 2 * 6 = 12  12 / 6 = 2  a * b = c c / b = a
  it "Divides a Gaussian" do
    @gauss=Gaussian.new 1.8,1.7888543819998317
    @gauss2=Gaussian.new 3,4
    @gauss3=@gauss/@gauss2
    #pp @gauss3.mu
    #pp @gauss3.sigma
    @gauss3.mu.should eql 1.5
    @gauss3.sigma.should eql 2.0
  end
end