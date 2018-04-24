# 把每行分割成各个字段，可以使用String#split方法
# 我们将正则表达式/\s*\|\s*/传递给split方法
# $LOAD_PATH << '../Chapter4'
require '../Chapter4/SongList'
require '../Chapter3/Song'
File.open("songdata") do |song_file|
  songs = SongList.new
  song_file.each do |line|
    file, length, name, title = line.chomp.split(/\s*\|\s*/)
    # chomp方法用于去除文件行尾含有的换行符，split方法根据正则表达式分割行
    name.squeeze!(" ") # 该方法用于去除名字中多余的空格
    songs.append(Song.new(title, name, length))
    # 可以再次使用split将冒号周围的时间字段分割出来
    mins, secs = length.split(/:/)
    print mins, " ", secs, "\n"
    # 我们还可以使用scan方法来分割时间
    mins, secs = length.scan(/\d+/)
    print mins, " ", secs, "\n"
    # 最后我们将时间以秒的形式存入Song对象
    songs.append(Song.new(title, name, mins.to_i * 60 + secs.to_i))
  end
  songArray = songs.get_songs
  puts songArray.each { |song| song}
end
