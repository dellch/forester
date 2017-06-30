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
  array = str.split(/\n/)
  out, out_chars, new_file_contents = "","",""
  #get rid of count line which is first line
  num_chars = array.delete_at(0).split(' ')[1].to_i
  begin_char_index = array[0].index(/(?<=\s)[0-9?]/)
  last_char_index = begin_char_index + num_chars  
  out = array.pop.match(/[A-Za-z_\(\)0-9]+/)[0]
  puts 'running...'  
  puts "#{num_chars.to_s} characters to process"
  #array is now OTU     ####### format
  (begin_char_index..last_char_index).each do |index|
    ones = []
    zeros = []
    
    array.each do |line|
      spot = line[index]
      next if spot=="?" || spot == " "
      case line[index]
        when '1'
          ones.push(line.match(/[A-Za-z_\(\)0-9]+/)[0])
        when '0'
          zeros.push(line.match(/[A-Za-z_\(\)0-9]+/)[0])
      end
  end
  otu_chars_hash = {}
  new_filename = "altered_"+filename+".txt"

  array.each do |line|
    otu = line.match(/[A-Za-z_\(\)0-9]+/)[0]
    chars = line.match(/(?<=\s)[0-9?]+/)[0].split('')
    out, out_chars = otu, chars if chars.all?{|chr|chr=="0"}
    otu_chars_hash[otu] = chars unless chars.all?{|chr|chr=="0"}
  end

  out_chars.each_with_index do |character, index|
    puts "SOMETHING IS WRONG WITH THE SCRIPT" if character != "0"
    ones = []
    zero = []
    otu_chars_hash.each_key do |key|
      ones.push(key) if otu_chars_hash[key][index] == "1"
      zero.push(key) if otu_chars_hash[key][index] == "0"
    end
    puts "MORE THAN ONE 0" if zero.length > 1
    out = "(#{out},(#{zero.first},(#{ones[0]},#{ones[1]})));\r\n"
    File.open(new_filename, 'a'){|f| f.puts(out)}    
    puts puts "lines processed: #{index.to_s} out of #{num_chars.to_s}"  if index%1000 == 0
  end
  puts "NEW FILE CREATED:  #{new_filename}"
else
  puts "ALERT: You must declare a filename:  usage should be \"ruby evgeny.rb NAME_OF_FILE\""
end
