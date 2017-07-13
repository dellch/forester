##########################################
##                                      ##
##               USAGE                  ##
##  type: "ruby evgeny.rb NAME_OF_FILE" ##
##  from command line in the directory  ##
##  of the file you're using            ##
##                                      ##
##########################################

original_file = ARGV[0]
filename = original_file
unless filename.nil?
  file = File.open(filename)
  str = file.read
  lines = str.split(/\n/)
  new_filename = "altered_#{filename}.txt"
  #get rid of count line which is first line
  num_chars = lines.delete_at(0).split(' ')[1].to_i
  begin_char_index = lines[0].index(/(?<=\s)[0-9?]/)
  last_char_index = begin_char_index + num_chars
  taxon_regex = /[A-Za-z_\(\)0-9]+/
  outgroup_index = lines.find_index{ |line| line[begin_char_index..last_char_index].match(/^0*$/) rescue false }
  outgroup = lines[outroup_index].match(taxon_regex)[0]
  five_percent_of_characters = (1.0*num_chars/20/100).floor*100

  puts 'running...'
  puts 'Getting outgroup taxon...'
  puts "#{outgroup} is the outgroup taxon"
  puts "processing file with #{num_chars.to_s} characters (#{lines.length.to_s} taxa)..."
  
  (begin_char_index..last_char_index).each do |index|
    ones, zeros = [], []
    
    lines.each do |line|
      next if line == outgroup_index
      spot = line[index]
      next if spot =='?' || spot == ' '
      case line[index]
        when '1'
          ones.push(line.match(taxon_regex)[0])
        when '0'
          zeros.push(line.match(taxon_regex)[0])
      end
    end


    unless ones.empty? and zeros.empty?
      puts "MORE THAN ONE 0s for #{outgroup}" if zeros.length > 1
      puts "MORE THAN TWO 1s for #{outgroup}" if ones.length > 2
      File.open(new_filename, 'a'){ |f| f.puts("#{outgroup},(#{zeros[0]},(#{ones[0]},#{ones[1]})));\r\n") }
    end

    if index%five_percent_of_characters == 0
      percent_complete = (100.0*index/num_chars).floor
      puts "characters processed: #{index.to_s} of #{num_chars.to_s}"
      puts percent_complete.to_s + '% complete'
    end
  end
  puts "Processing complete\r\nNEW FILE CREATED:  #{new_filename}"
else
  puts "ALERT: You must declare a filename:  usage should be \"ruby evgeny.rb NAME_OF_FILE\""
end
