#!/usr/bin/env ruby
#
#  C/C++/Java (and C#?) Extreme Code Metrics program
#  Copyright (c) XPUtah (Jeff Grover and Zhon Johansen) 2000-2002.  All rights reserved.
#

# Calculates what directories or files are using up the most disk space

# Bug in UNIX version of 'find' = if you don't have permissions to open
# a visited directory, it will quit by raising an exception. You can 
# use "findfault" (fault-tolerant find) to catch the exception, and
# avoid this behavior... (or just login as root with the original "find"!)

require 'find'      # find has a bug

if $0 == __FILE__

	start = Time.new
	
	if ARGV.length < 1
		puts "\nUsage:  dirhog start_directory [max_items] [files|dirs]\n\n"
		puts "Examples:\n"
		puts "   dirhog C:          = 100 dirs on C drive using most space\n"
		puts "   dirhog . 10 files  = 10 largest files in current subdirs.\n\n"
	else
		max_items = 100
		show_files_not_dirs = false
	
		max_items = ARGV[1].to_i if ARGV.length > 1
		show_files_not_dirs = true if (ARGV.length > 2 and ARGV[2].upcase == "FILES")
		dirs = {}
		
		puts "\n\nDirectory Hog Hard Disk Cleanup Utility:\n\n"
		STDERR.puts
		
		Find.find(ARGV[0]) { |path_name|
      next if File.directory?(path_name)
			
			file = File.basename(path_name)
			directory = File.dirname(path_name)
			
			show_files_not_dirs ? key = path_name : key = directory
			STDERR.puts "Processing " + key if dirs[key] == nil			

			dirs[key] = 0 if dirs[key] == nil
			dirs[key] += File.size(path_name) if File.exists?(path_name)
		}
		
		STDERR.puts "\n\n"
		puts "    Size                               Item"
		puts " ---------- ------------------------------------------------------------------"
		
		count = 0
		dirs.sort{ |a, b| b[1] <=> a[1] }.each { | dir, size |
			count += 1
			break if count > max_items
			printf("%11d %s\n", size, dir) 
		}
		
		STDERR.puts"\n\nProcessing took:  #{Time.new - start} seconds.\n\n"
	end
end
