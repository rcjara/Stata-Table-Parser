require "Bacon"

require File.dirname(__FILE__) + '/../lib/NumDecoder.rb'

describe NumDecoder do
  it "should be able to handle 2.95615E6" do
    NumDecoder.decode("2.95615E6").should.equal 2956150
  end

  it "should be able to handle 349,075" do
    NumDecoder.decode("349,075").should.equal 349075
  end

  it "should be able to handle 349,075.932" do
    NumDecoder.decode("349,075.932").should.equal 349075.932
  end
end
