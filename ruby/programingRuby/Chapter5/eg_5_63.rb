# 把每行分割成各个字段，可以使用String#split方法
# 我们将正则表达式/\s*\|\s*/传递给split方法
# $LOAD_PATH << '../Chapter4'
require '../Chapter4/SongList'
require '../Chapter3/Song'
File.open("songdata") do |song_file|
  songs = SongList.new
  song_file.each do |line|
    file, length, name, title = line.chomp.split(/\s*\|\s*/)
    songs.append(Song.new(title, name, length))
  end
  songArray = songs.get_songs
  puts songArray.each { |song| song}
end
