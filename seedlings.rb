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
  counts = array.delete_at(0)
  #array is now OTU     ####### format
  otu_chars_hash = {}

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
    new_file_contents += "(#{out},(#{zero.first},(#{ones[0]},#{ones[1]})));\r\n"
  end

  new_filename = "altered_"+filename+".txt"
  File.open(new_filename, "w"){|f|f.write(new_file_contents)}
  puts "NEW FILE CREATED:  #{new_filename}"
else
  puts "ALERT: You must declare a filename:  usage should be \"ruby evgeny.rb NAME_OF_FILE\""
end
