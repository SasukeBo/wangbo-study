line = "Perl and Python"
if line =~ /Perl|Python/
  puts "Scripting language mentioned: #{line}"
end

#一些有用的正则表达式
#/\d\d:\d\d:\d\d\     # a time such as 12:34:56
#/Perl.*Python/       # Perl, zero or more chars, then Python
#/perl Python/        # Perl, a space, and Python
#/Perl *Python/       # Perl, zero or more spaces, and Python
#/Perl +Python/       # Perl, one or more spaces,and Python
#/Perl\s+Python/      # Perl, whitespace charaters, then Python
#/Ruby (Perl|Python)/ # Ruby, a space, and either Perl or Python
#

line = "12:34:56"
puts "#{line}" if line =~ /\d\d:\d\d:\d\d/

line = "Perl a b c Python"
puts "#{line}" if line =~ /Perl.*Python/

line = "Ruby Python"
puts "#{line}" if line =~ /Ruby (Perl|Python|Elixir)/

puts line.sub(/Ruby/, 'Elixir') # replace first 'Perl' with 'Ruby'

line = "Ruby Ruby Ruby Ruby"
puts line.gsub(/Ruby/, 'Elixir') #replace every 'Ruby' with 'Elixir'

line = "Ruby Python Ruby Python"
puts line.gsub(/Ruby|Python/, 'Elixir') #replace every 'Ruby' or 'Python' with 'Elixir'




