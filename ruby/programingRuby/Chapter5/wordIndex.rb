class WordIndex
  def initialize
    @index = {}
  end
  def add_to_index(obj, *phrases)
    phrases.each do |phrase|
      phrase.scan(/\w[-\w']+/) do |word|
        word.downcase!
        @index[word] = [] if @index[word].nil?
        @index[word].push(obj)
      end
    end
  end
  def lookup(word)
    @index[word.downcase]
  end
end
