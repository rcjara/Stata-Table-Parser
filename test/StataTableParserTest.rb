require File.dirname(__FILE__) + '/../lib/StataTableParser.rb'
require File.dirname(__FILE__) + '/StataTableParserHelper.rb'

include StataTableParserHelper

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
    
    it "should show that it has multiple segments" do
      @parser.first_table.num_segments.should == 2
    end
    
    it "should have the proper column names" do
      @parser.first_table.col_names.should == one_double_wide_table_col_names
    end

    it "should have the proper row names" do
      @parser.first_table.row_names.should == one_double_wide_table_row_names
    end
    
    it "should have the proper column var name" do
      @parser.first_table.col_var_name.should == "occ21"
    end

    it "should have the proper row var name" do
      @parser.first_table.row_var_name.should == "bea67"
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
      @parser.first_table.num_cols.should == 5
    end
    
    it "should have the right number of rows" do
      @parser.first_table.num_rows.should == 81
    end
    
    it "should show that it has a single segment" do
      @parser.first_table.num_segments.should == 1
    end
    
    it "should have the proper column names" do
      @parser.first_table.col_names.should == one_simple_table_col_names
    end
    
    it "should have the proper row names" do
      @parser.first_table.row_names.should == one_simple_table_row_names
    end
  end
  
end