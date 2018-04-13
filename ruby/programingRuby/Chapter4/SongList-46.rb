$LOAD_PATH << '.'
require 'SongList'

class SongList
  def with_title(title)
    for i in 0...@songs.length
      return @songs[i] if title == @songs[i].name
    end
    # puts "这是第一种写法"
    return nil
  end
end
# 下面是另一种写法
class SongList
  def with_title(title)
    @songs.find {|song| title == song.name }
    # The method find is an iterator.
    # puts "这是第二种写法"
  end
end
=begin
songlist = SongList.new
songlist.with_title("name")
=end
