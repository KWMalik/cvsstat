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

File.open('logfile.log') do |file|
    puts file
    
    usenext = false

     count = 0

    file.each_line do |line|
      
      if usenext
          #puts line
          puts '+'
          
          parts = line.strip.split(';')
          
          date_string = parts[0].split(':')[1].strip
          
          #puts "'#{date_string}'"
          #puts Date.parse(date_string)
          
          filename = parts[parts.size - 1].split(':')[1]
          filedata = Filedata.new(filename)
          filedata_map[filename] = filedata
          
          line_parts = parts.select do |item| 
          #  puts item
            (item =~ /^ *lines*/)  != nil
          end
          
          if (line_parts.size > 0) 
            lines_string = line_parts[0]
           # puts lines_string
            
            filedata.lines_added = Integer(lines_string.scan(/\+(.*) /)[0][0])
            filedata.lines_removed = Integer(lines_string.scan(/-.*/)[0])
          end
          
          
          #puts filedata
          
            
      end
      
      if line =~ /^revision*/
        usenext = true
      else
        usenext = false
      end
      
      
    end
  end
  
  puts filedata_map.size
