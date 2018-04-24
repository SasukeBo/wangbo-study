class SongList
  def initialize
    @songs = Array.new
  end
end
# 增加append方法添加歌曲
class SongList
  def append(song)
    @songs.push(song)
    self # return a reference of songs to the current SongList object
  end
end
# 增加delete_first和delete_last方法
class SongList
  def delete_first
    @songs.shift
  end
  def delete_last
    @songs.pop
  end
end
# Method [] accesses elements by index.
class SongList
  def [](index)
    return @songs[index]
  end
  def get_songs
    return @songs
  end
end

# 对一个类的定义可以接着之前的定义继续增加方法，就同上面的例子一样




