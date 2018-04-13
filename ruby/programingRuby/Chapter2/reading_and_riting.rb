printf("Number: %5.2f,\nString: %s\n", 1.23, "hello") #Prints its arguements under the control of a format string (just like printf in C )

line = gets #gets method can receive the next line from your program's standard input stream.
printf line

#the gets method has a side effect :as well as returning the line just read, it also stores it into the global variable $_. If you call print with no arguement, It prints the contents of $_.
=begin
while gets
  if /Ruby/   #这种书写方式已经被淘汰了，此处只是个例子
    print
    break
  end
end
=end

#The Ruby way to write this would be to use a iterator and the predefined object ARGF,which represents the program's input files.
#
ARGF.each {
  |line2| print "Ruby matched \n" if line2 =~ /Ruby/
  break
}

#You could write it even more concisely
#
#print ARGF.grep(/Ruby/) #这个方法不好使

