require 'spec_helper'

class Foo
  include LazyResource::Attributes
end

describe LazyResource::Attributes do
  before :each do
    Foo.attribute(:name, String)
    @foo = Foo.new
  end
  
  describe '.attribute' do
    it 'adds the attribute to the attributes hash' do
      Foo.attributes[:name].should == { :type => String, :options => {} }
    end
    
    it 'creates a getter method' do
      @foo.respond_to?(:name).should == true
    end

    it 'creates a setter method' do
      @foo.respond_to?(:name=).should == true
    end

    it 'creates a question method' do
      @foo.respond_to?(:name?).should == true
    end
  end

  describe '.attributes' do
    it 'returns a hash of the defined attributes' do
      Foo.attributes.should == { :name => { :type => String, :options => {} } }
    end
  end
end
