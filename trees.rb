################################################
##                                            ##
##               USAGE                        ##
##  type: "ruby trees.rb NAME_OF_FILE" ##
##  from command line in the directory        ##
##  of the file you're using                  ##
##                                            ##
################################################

filename = ARGV[0]

unless filename.nil?
  file = nil
  File.open(filename){|f| file = f.read}

  #create blank files
  file_no_poly = "NO_POLY_"+filename+".txt"
  file_with_poly = "WITH_POLY_"+filename+".txt"
  file_additional = "ADDITIONAL_FILE_"+filename+".txt"

  array = file.split(/\n/)
  #get number of characters from first line of array
  num_chars = array.delete_at(0).split(' ')[1].to_i
  begin_char_index = array[0].index(/(?<=\s)[0-9?]/)
  last_char_index = begin_char_index + num_chars
  taxon_regex = /[A-Za-z_\(\)0-9]+/
  out = array.pop.match(taxon_regex)[0]
  puts 'running...'
  puts "#{num_chars.to_s} characters to process"
  #from first character, to last character
  (begin_char_index..last_char_index).each do |index|
    ones = []
    zeros = []

    #use same spot in each line of array
    array.each do |line|
      spot = line[index]
      next if spot == '?' || spot == ' '  #ignore ? spots
      case line[index]
        when '1'
          ones.push(line.match(taxon_regex)[0])
        when '0'
          zeros.push(line.match(taxon_regex)[0])
      end
    end

    #append to file after you've done each line
    #this is how things should look:
    #################################################################################################
    # Matrix
    #
    # A      010011
    # B      010011
    # C      110010
    # D      100110
    # Out    000000
    #
    # I. How trees suppose to looks like:
    #
    #                                   a. No POLY:
    #
    #     (Out,(A,B,(C,D))); - first character,
    #     (Out,(D,(A,B,C))); - second character,
    #     (Out,(A,B,C,D)); - fifth character,
    #     (Out,(C,D,(A,B))); - character six,
    #
    #     Characters three and four are polytomies = must be skipped!
    #
    # b. With POLY:
    #
    #     (Out,(A,B,(C,D))); - first character,
    #     (Out,(D,(A,B,C))); - second character,
    #     (Out,A,B,C,D); - third character,
    #     (Out,A,B,C,D); - fourth character,
    #     (Out,(A,B,C,D)); - fifth character,
    #     (Out,(C,D,(A,B))); - character six,​
    #
    # So, all characters are represented in Newick form - neither is skipped = polytomies are included.
    #
    #     c. ADDITIONAL:
    #
    #     (Out,A,B,(C,D)); - first character,
    #     (Out,D,(A,B,C)); - second character,
    #     (Out,(A,B,C,D)); - fifth character,
    #     (Out,C,D,(A,B)); - character six,
    #
    #     Characters three and four are polytomies = must be skipped!
    ################################################################################
    unless ones.empty? and zeros.empty?
      if ones.length <= 1
        out_with_poly = "(#{([out]+ones+zeros).join(',')});\r\n"
        File.open(file_with_poly, 'a'){|f| f.puts(out_with_poly)}
      else
        if zeros.length == 0
          out_with_poly = out_no_poly = out_additional = "(#{out},(#{ones.join(',')}));\r\n"
          File.open(file_with_poly, 'a'){|f| f.puts(out_with_poly)}
          File.open(file_no_poly,   'a'){|f| f.puts(out_no_poly)}
          File.open(file_additional, 'a'){|f| f.puts(out_additional) }
        else
          out_no_poly = out_with_poly = "(#{out},(#{ zeros.join(',') },(#{ ones.join(',') })));\r\n"
          File.open(file_no_poly,   'a'){|f| f.puts(out_no_poly)}
          File.open(file_with_poly, 'a'){|f| f.puts(out_with_poly)}
          out_additional = "(#{([out]+zeros).join(',')},(#{ones.join(',')}));\r\n"
          File.open(file_additional, 'a'){|f| f.puts(out_additional) }
        end
      end
    end

    percent_complete = (100.0*index/num_chars).floor
    print "#{percent_complete}% complete - lines processed: #{index.to_s} out of #{num_chars.to_s}\r"
  end
  puts "\nProcessing complete."
  puts "NEW FILE CREATED:  #{file_no_poly}"
  puts "NEW FILE CREATED:  #{file_with_poly}"
  puts "NEW FILE CREATED:  #{file_additional}"
else
  puts "ALERT: You must declare a filename:  usage should be \"ruby trees.rb NAME_OF_FILE\""
end
