#!/usr/bin/ruby
require "fileutils"

action = String(ARGV[0]).downcase
subAction = String(ARGV[1]).downcase
subAction2 = String(ARGV[2]).downcase
subAction3 = String(ARGV[3]).downcase

# puts "you typed #{action} and #{subAction} and #{subAction2} and #{subAction3}"

ARGV.clear
##
# => Check for an extension
##
def extension?(filename) 
	filename.match( %r/\.([^\.]+)$/ ) do |ext|
		if  ext != nil
			return true
		else
			return false
		end
	end
end
##
#	Here is where the file they want to be synced (number one) and its path
##
def createFile(filename)
	newFile = String(filename)
	File.new(newFile, "w+")
	puts "...File Created!"
	return newFile
end

##
# => add file to profile
##
def addToProfile()
	puts "You could always do this manually. This is actually easier."
	print "Would you like to continue? [y/n]"
	ans = gets.chomp
	if ans == "n"
		return
	else
	end
	puts "Which Profile would you like to add to?"
	puts "====PROFILES====="
	system("ls Profiles")
	puts "================="
	filename = gets.chomp
	path = "./Profiles/" + filename
	if File.exists?(path)
		File.open(path, "r+") do |f|
			line = f.to_enum
			numOfFiles = Integer(line.next)
			puts "The number of files is #{numOfFiles}"
			begin
				puts "Enter name file + extension (ex. Smells_Like_Teen_Spirit.mp3)\n Make sure it is a valid filename."
				filename = gets.chomp
			end while extension?(filename) != true

			puts "Enter the source path. Do NOT include the filename"
			source = gets.chomp

			puts "Enter the desination path. Do NOT include the filename"
			destination = gets.chomp
			##
			# => FINISH
			##
		end
		File.close
	else
		puts "File does not exist"
		return
	end
end

##
#	Here is where the file they want to be synced in (number two) and its path
##
def createSync(filename) 
	print "Enter path of where you would like to sync: "
	path = gets.chomp
	File.new(path + filename)
end

##
#	In this method, I plan on creating a Profile, where the 
#	user types in the file they want Hopped, the Path, then where
#	they want it to be synced in, and its path. Then it will be written into
#	a file, called its profile.
##
def createProfile()
	#Create File
	puts "What would you like to call your profile?"
	puts "====PROFILES====="
	system("ls Profiles")
	puts "================="
	filename = gets.chomp
	path = "./Profiles/" + filename
	if filename.include? ".txt"
		puts "You do not need to include the extension"
		return
	end
	if File.exists?(path) 
		puts "Profile already exists"
	else
		filename += ".txt"
		file = createFile(filename)
		path = "./Profiles/#{filename}"
		system("mv #{filename} Profiles")
		File.open(path, "w") do |aFile|
			aFile.write("0")
		end
	end
	# Open file, and write in it
end

def readAndWrite(profile)
	path = "./Profiles/" + profile
	#read from ...
	if File.exists?(path)
		print "Reading File...\n"
		f = File.open(path, "r")
		line_enum = f.to_enum
		numOfFiles = line_enum.next
		counter = Integer(numOfFiles) * 3

		while counter > 0 do
			# copy to file
			fileToCopy = line_enum.next
			# source destination
			source = line_enum.next.gsub("\n", "").gsub(" ", "\\ ") + fileToCopy.gsub("\n", "").gsub(" ","\\ ")
			#puts source
			destination = line_enum.next.gsub(" ", "\\ ")
			#puts destination
			counter -= 3
			system("cp #{source} #{destination}")
			#puts "Files left: " + String(counter / 3) + "/#{numOfFiles}"
		end
		f.close
	else
		puts "Profile does not exist"
	end
end

# action : new
if action == "new"
	if subAction == "profile"
		createProfile()
	else
		puts "Invalid action"
	end
end
# action : add
if action == "add"
	addToProfile()
end
# action : create sync
if action == "sync"
	puts "====PROFILES====="
	system("ls Profiles")
	puts "================="
	puts "Which Profile? "	
	profile = gets.chomp

	if (subAction == "cont" and subAction2 == "")
		puts "Loop interval default: 5 minutes"
		loop do 
			readAndWrite(profile)
			puts "Complete"
			sleep(300)
		end
	elsif (subAction == "cont" and subAction2 == "intv" and subAction3 != "")
		interval = Integer(subAction3) * 60
		puts "Loop interval: #{interval/60} minutes" 
		loop do
			readAndWrite(profile)
			puts "Complete"
			sleep(interval)
		end
	elsif (subAction == "")
		readAndWrite(profile)
		puts "Complete"
	else
		puts "Invalid Input"	
	end
end

#null action?
if action == ""
	puts "Please enter action"
end


