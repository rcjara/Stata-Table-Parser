require File.dirname(__FILE__) + '/../lib/StataTableParser.rb'

describe StataTableParser do
  context "bigfile.txt" do
    before(:each) do
      @parser = StataTableParser.new(File.dirname(__FILE__) + "/../TestTables/bigfile.txt")
    end
    
    it "should be able to fine the right number of tables in the file" do
      @parser.num_tables.should == 17
    end
    
  end
  
  context "OneDoubleWideTable.txt" do
    before(:each) do
      @parser = StataTableParser.new(File.dirname(__FILE__) + "/../TestTables/OneDoubleWideTable.txt")
    end
    
    it "should be able to fine the right number of tables in the file" do
      @parser.num_tables.should == 1
    end
    
    it "should have the right number of columns" do
      @parser.first_table.num_cols.should == 22
    end
    
    it "should have the right number of rows" do
      @parser.first_table.num_rows.should == 81
    end
  end
  
  context "OneSimpleTable" do
    before(:each) do
      @parser = StataTableParser.new(File.dirname(__FILE__) + "/../TestTables/OneSimpleTable.txt")
    end
    
    it "should be able to fine the right number of tables in the file" do
      @parser.num_tables.should == 1
    end
    
    it "should have the right number of columns" do
      @parser.first_table.num_cols.should == 16
    end
    
    it "should have the right number of rows" do
      @parser.first_table.num_rows.should == 81
    end
  end
  
end