def substrings(word, dictionary)
  dictionary.reduce(Hash.new(0)) { |hash, substring|
    substring_count = word.downcase.scan(substring).length
    if substring_count > 0
      hash[substring] += substring_count
    end
    hash
  }
end

dictionary = ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"]
substrings("Howdy partner, sit down! How's it going?", dictionary)