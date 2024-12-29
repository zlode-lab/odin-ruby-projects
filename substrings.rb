def substrings(word, dictionary)
  dictionary.each_with_object(Hash.new(0)) do |substring, hash|
    substring_count = word.downcase.scan(substring).length
    hash[substring] += substring_count if substring_count > 0
  end
end

dictionary = %w[below down go going horn how howdy it i low own part partner sit]
substrings("Howdy partner, sit down! How's it going?", dictionary)
