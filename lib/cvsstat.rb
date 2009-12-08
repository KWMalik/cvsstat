class Filedata
  attr_accessor :lines_added, :lines_removed, :file_name
  
  def initialize(file_name)
    @file_name = file_name
    @lines_added = @lines_removed = 0
  end
  
  def churn
    @lines_added + @lines_removed
  end
  
  def to_s
    "#{@file_name}:  + #{@lines_added} - #{lines_removed} churn (#{churn})"
  end
end

puts File.exist?('logfile.log')

filedata_map = {}

start_date = Date.parse("2009-11-06")
end_date = Date.parse("2009-12-07")


File.open('logfile.log') do |file|
    puts file
    
    usenext = false

     count = 0

    file.each_line do |line|
      
      if usenext
          #puts line
          #puts '+'
          
          parts = line.strip.split(';')
          
          date_string = parts[0].split(':')[1].strip
          
          #puts "'#{date_string}'"
          #puts Date.parse(date_string)
          
          revision_date = Date.parse(date_string)
          
          if (revision_date >= start_date and revision_date <= end_date)
            filename = parts[parts.size - 1].split(':')[1].strip
            
            
            filedata = filedata_map[filename]  || Filedata.new(filename)
            line_parts = parts.select do |item| 
            #  puts item
              (item =~ /^ *lines*/)  != nil
            end

            if (line_parts.size > 0) 
              lines_string = line_parts[0]
             # puts lines_string
              filedata.lines_added += Integer(lines_string.scan(/\+(.*) /)[0][0])
              filedata.lines_removed += Integer(lines_string.scan(/-(.*)/)[0][0])
            end

            filedata_map[filename]  = filedata
          end
          
            
      end
      
      if line =~ /^revision*/
        usenext = true
      else
        usenext = false
      end
      
      
    end
  end
  
  puts "Files found with revision: #{filedata_map.size}"
  
  f = File.new("output #{start_date} - #{end_date}.csv","w")
  
  f.puts "filename,added,removed,churn"
  filedata_map.each do |key,value|
    f.puts "#{key.strip},#{value.lines_added},#{value.lines_removed},#{value.churn}"
  end
  f.close