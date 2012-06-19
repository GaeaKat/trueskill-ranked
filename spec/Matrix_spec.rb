require 'spec_helper'
require 'pp'


describe Matrix do

  it "makes a new Matrix with func" do
    newFunc=Proc.new do |width,height|
      Enumerator.new do |yielder|
        10.times do |c|
          test4=[c,c],c
          yielder.yield(test4)
        end
        width.call(10)
        height.call(10)
      end
      
    end
    test=Matrix.new(nil,nil,nil,:func=>newFunc)
    test.width.should eql 10
    test.height.should eql 10
    test[9,9].should eql 9
    
    #pp test.size
  end
  it "Tries to assign to a matrix" do
    test=Matrix.new([[1,2,3],[1,2,3],[1,2,3]])
    test[1,1].should eql 2 
    test[1,1]=9
    test[1,1].should eql 9
  end
  it "Transposes a Matrix" do
    test=Matrix.new([[1,2,3],[4,5,6],[7,8,9]])
    test[1,1].should eql 5
    test2=test.transpose
    test2[1,1].should eql 5
  end
  it "Determinant a Matrix" do
    test=Matrix.new([[2, 2, 3], [4, 5, 6], [7, 8, 9]])
    test[1,1].should eql 5
    test2=test.determinant
    pp test2
  end
  it "Adjucate a Matrix" do
    test=Matrix.new([[2, 2, 3], [4, 5, 6], [7, 8, 9]])
    test[1,1].should eql 5
    test2=test.adjucate
    pp test2
  end
  it "Checks Matrix cloning" do
    test=Matrix.new([[1,2,3],[4,5,6],[7,8,9]])
    test[1,1].should eql 5
    test2=test.clone
    test2[1,1]=9
    test[1,1].should eql 5
    test2[1,1].should eql 9
  end
  it "Minor's a Matrix" do
   test=Matrix.new([[1,2,3],[4,5,6],[7,8,9]])
    test[1,1].should eql 5
    test2=test.minor 1,1
    #pp test2
  end 
  
  it "makes a new Matrix with an array" do
    test=Matrix.new([[1,2,3],[1,2,3],[1,2,3]])
  end
  
end