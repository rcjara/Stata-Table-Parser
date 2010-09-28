require "Bacon"

require File.dirname(__FILE__) + '/../lib/StataTableParser.rb'
require File.dirname(__FILE__) + '/StataTableParserHelper.rb'

include StataTableParserHelper

describe StataTableParser do
  describe "bigfile.txt" do
    before do
      @parser = StataTableParser.new(File.dirname(__FILE__) + "/../TestTables/bigfile.txt")
    end
    
    it "should be able to find the right number of tables in the file" do
      @parser.num_tables.should == 23
    end
    
    it "should be able to csv out without an error" do
      @parser.csv_out(File.dirname(__FILE__) + "/../TestTables/bigfileout.csv")
    end

	it "should have the right types of tables" do
	  @parser.table_types.should == [:table, :table, :table, :table, :table, :table, :table, :table, :table, :table, :table, :table, :table, :table, :table, :table, :table, :tab, :tab, :tab, :tab, :tab, :tab] 
	end
  end

  describe "Single Variable Table" do
    before do
      @parser = StataTableParser.new(File.dirname(__FILE__) + "/../TestTables/SingleVarTable.txt")
    end

	it "should have the right csv output" do
      @parser.csv_out(File.dirname(__FILE__) + "/../TestTables/SingleVarTableOut.csv")
      File.read(File.dirname(__FILE__) + "/../TestTables/SingleVarTableOut.csv").should == File.read(File.dirname(__FILE__) + "/../TestTables/SingleVarTable.csv")
	end
  end

  describe "AltSmallTab.txt" do
    before do
      @parser = StataTableParser.new(File.dirname(__FILE__) + "/../TestTables/AltSmallTab.txt")
    end
    
    it "should be able to find the right number of tables in the file" do
      @parser.num_tables.should == 1
    end
    
    it "should be able to csv out without an error" do
      @parser.csv_out(File.dirname(__FILE__) + "/../TestTables/SmallTabOut.csv")
    end

	it "should have the right types of tables" do
	  @parser.table_types.should == [:tab] 
	end

	it "should get the right csv output" do
      @parser.csv_out(File.dirname(__FILE__) + "/../TestTables/AltSmallTabOut.csv")
      File.read(File.dirname(__FILE__) + "/../TestTables/AltSmallTabOut.csv").should == File.read(File.dirname(__FILE__) + "/../TestTables/AltSmallTab.csv")
	end
  end
  
  describe "OneDoubleWideTable.txt" do
    before do
      @parser = StataTableParser.new(File.dirname(__FILE__) + "/../TestTables/OneDoubleWideTable.txt")
    end
    
    it "should be able to find the right number of tables in the file" do
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
    
    it "should have the right number of cells" do
      @parser.first_table.num_cells.should == 1
    end
  end
  
  describe "OneSimpleTable" do
    before do
      @parser = StataTableParser.new(File.dirname(__FILE__) + "/../TestTables/OneSimpleTable.txt")
    end
    
    it "should be able to find the right number of tables in the file" do
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
    
    it "should have the right number of cells" do
      @parser.first_table.num_cells.should == 1
    end
  end
  
  describe "SmallWideTable" do
    before do
      @parser = StataTableParser.new(File.dirname(__FILE__) + "/../TestTables/SmallWideTable.txt")
    end
    
    it "should be able to output a csv file meeting specifications" do
      @parser.csv_out(File.dirname(__FILE__) + "/../TestTables/output.csv")
      File.read(File.dirname(__FILE__) + "/../TestTables/output.csv").should == File.read(File.dirname(__FILE__) + "/../TestTables/SmallWideTable.csv")
    end
    
    it "should be able to find the right number of tables in the file" do
      @parser.num_tables.should == 1
    end
    
    it "should have the right number of columns" do
      @parser.first_table.num_cols.should == 22
    end
    
    it "should have the right number of rows" do
      @parser.first_table.num_rows.should == 6
    end
    
    it "should show that it has two segments" do
      @parser.first_table.num_segments.should == 2
    end
    
    it "should have the proper column names" do
      @parser.first_table.col_names.should == one_double_wide_table_col_names
    end
    
    it "should have the right number of cells" do
      @parser.first_table.num_cells.should == 1
    end
    
    it "should be able to output into excel xml" do
      @parser.xml_out(File.dirname(__FILE__) + "/../TestTables/SmallWideTableBasicOut.xml")
      File.read(File.dirname(__FILE__) + "/../TestTables/SmallWideTableBasicOut.xml").should == File.read(File.dirname(__FILE__) + "/../TestTables/SmallWideTableBasic.xml")
    end
    
    it "should be able to output into excel xml with row totals" do
      @parser.xml_out(File.dirname(__FILE__) + "/../TestTables/SmallWideTableRowTotalsOut.xml", :row_totals => true)
      File.read(File.dirname(__FILE__) + "/../TestTables/SmallWideTableRowTotalsOut.xml").should == File.read(File.dirname(__FILE__) + "/../TestTables/SmallWideTableRowTotals.xml")
    end
    
    it "should be able to output into an excel xml with percents" do
      @parser.xml_out(File.dirname(__FILE__) + "/../TestTables/SmallWideTablePercentsByRowOut.xml", :row_percents => true)
      File.read(File.dirname(__FILE__) + "/../TestTables/SmallWideTablePercentsByRowOut.xml").should == File.read(File.dirname(__FILE__) + "/../TestTables/SmallWideTablePercentByRow.xml")
    end
  end
    
  describe "multicell table, wide" do
    before do
      @parser = StataTableParser.new(File.dirname(__FILE__) + "/../TestTables/MultiCell.txt")
    end
    
    it "should be able to find the right number of tables in the file" do
      @parser.num_tables.should == 1
    end

    it "should have the right number of columns" do
      @parser.first_table.num_cols.should == 11
    end

    it "should have the right number of rows" do
      @parser.first_table.num_rows.should == 129
    end
    
    it "should have the right number of cells for the row column interactions" do
      @parser.first_table.num_cells.should == 2
    end
    
    it "should get the expected output" do
      @parser.csv_out(File.dirname(__FILE__) + "/../TestTables/MultiCellWideOut.csv", {:wide_cells => true} )
      File.read(File.dirname(__FILE__) + "/../TestTables/MultiCellWideOut.csv").should == File.read(File.dirname(__FILE__) + "/../TestTables/ExpectedMultiCell.csv")
    end
  end
  
  describe "very simple table" do
    before do
      @parser = StataTableParser.new(File.dirname(__FILE__) + "/../TestTables/VerySimpleTable.txt")
    end
    
    it "should be able to find the right number of tables in the file" do
      @parser.num_tables.should == 1
    end

    it "should have the right number of columns" do
      @parser.first_table.num_cols.should == 5
    end

    it "should have the right number of rows" do
      @parser.first_table.num_rows.should == 11
    end

    it "should have the right number of cells for the row column interactions" do
      @parser.first_table.num_cells.should == 1
    end
  end
  
end
