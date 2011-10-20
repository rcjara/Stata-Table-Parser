require File.dirname( File.expand_path(__FILE__)) + '/StataTable.rb'


HORIZONTAL_BORDER = /^-----/

class StataTableParser
  def initialize(filename)
    @filename = filename
    @lines = File.read(filename).split(MAC_WIN_UNIX_LINE_BREAKS)
  end

  def csv_out(filename = nil, options = {})
    unless filename
      filename = @filename.gsub(/\.txt|\.log/, ".csv")
    end
    File.open(filename, 'w') do |w|
      tables.each do |table|
        w << table.to_csv
        w << "\n\n"
      end
    end
  end

  def xml_out(filename = nil, options = {})
    unless filename
      filename = @filename.gsub(/\.txt|\.log/, ".xml")
    end
  num_rows = tables.inject(0) {|sum, table| sum + 1 + table.num_rows}
    num_cols = tables.inject(0) {|widest, table| table.num_cols > widest ? table.num_cols : widest }
    File.open(filename, 'w') do |w|
    w << xml_header(num_rows, num_cols)
      tables.each do |table|
        w << table.to_xml(options)
        #w << "   <Row/>\n"
      end
    w << xml_footer
    end
  end

  def num_tables
    table_indexes.length
  end

  def first_table
    tables.first
  end


  def table_indexes
    return @table_indexes if @table_indexes
    @table_indexes = []
    @lines.each_with_index do |line, i|
      @table_indexes << i if line.one_match?(/^\.\s+tab/)
    end
    @table_indexes
  end

  def tables
    return @tables if @tables
    @tables = []
    indexes_with_end = table_indexes + [-1] #adding the -1 so that when each_cons is run, it will create slices that proceed all the way to the end of the file.
    indexes_with_end.each_cons(2) do |first, second|
      @tables << StataTable.new(@lines[first..second])
    end
    @tables
  end

  def table_types
    tables.collect { |table| table.table_type }
  end

  def xml_header(num_rows, num_cols)
<<-EOS
<?xml version="1.0"?>
<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:o="urn:schemas-microsoft-com:office:office"
 xmlns:x="urn:schemas-microsoft-com:office:excel"
 xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:html="http://www.w3.org/TR/REC-html40">
 <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
  <Version>12.0</Version>
 </DocumentProperties>
 <OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">
  <AllowPNG/>
 </OfficeDocumentSettings>
 <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">
  <WindowHeight>13560</WindowHeight>
  <WindowWidth>21600</WindowWidth>
  <WindowTopX>740</WindowTopX>
  <WindowTopY>-260</WindowTopY>
  <Date1904/>
  <ProtectStructure>False</ProtectStructure>
  <ProtectWindows>False</ProtectWindows>
 </ExcelWorkbook>
 <Styles>
  <Style ss:ID="Default" ss:Name="Normal">
   <Alignment ss:Vertical="Bottom"/>
   <Borders/>
   <Font ss:FontName="Verdana"/>
   <Interior/>
   <NumberFormat/>
   <Protection/>
  </Style>
  <Style ss:ID="s27">
   <Borders>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s28">
   <Borders>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s29">
   <Borders>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s30">
   <Borders>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s31">
   <Borders/>
   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s32">
   <Borders>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s33">
   <Borders>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s34">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s35">
   <Borders>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s36">
   <Borders>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s37">
   <Borders/>
   <NumberFormat ss:Format="#,##0"/>
  </Style>
  <Style ss:ID="s38">
   <Borders>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <NumberFormat ss:Format="#,##0"/>
  </Style>
  <Style ss:ID="s39">
   <Borders>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s40">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <NumberFormat ss:Format="#,##0"/>
  </Style>
  <Style ss:ID="s41">
   <Borders>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <NumberFormat ss:Format="#,##0"/>
  </Style>
  <Style ss:ID="s42">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>
  </Style>
 </Styles>
 <Worksheet ss:Name="bea67 by occ21">
  <Table ss:ExpandedColumnCount="#{num_cols + 2}" ss:ExpandedRowCount="#{num_rows + 2}" x:FullColumns="1"
   x:FullRows="1">
    EOS
  end

  def xml_footer
    <<-EOS
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <Print>
    <ValidPrinterInfo/>
    <PaperSizeIndex>0</PaperSizeIndex>
    <HorizontalResolution>-4</HorizontalResolution>
    <VerticalResolution>-4</VerticalResolution>
   </Print>
   <PageLayoutZoom>0</PageLayoutZoom>
   <Selected/>
   <LeftColumnVisible>0</LeftColumnVisible>
   <Panes>
    <Pane>
     <Number>1</Number>
     <ActiveRow>1</ActiveRow>
     <ActiveCol>1</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
 </Worksheet>
</Workbook>
    EOS
  end
end


