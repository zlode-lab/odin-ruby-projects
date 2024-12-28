def shift_num(byte, shift_factor, min_byte, max_byte)
  if byte.between?(min_byte, max_byte)
    byte += shift_factor
    byte = byte + min_byte - max_byte - 1 if byte > max_byte
  end
  byte
end

def caesar_cipher(string, shift_factor)
  shift_factor %= 26
  shifted_string = string.bytes.map do |letter|
    letter = shift_num(letter, shift_factor, 97, 122)
    letter = shift_num(letter, shift_factor, 65, 90)
    letter
  end
  shifted_string.pack('c' * shifted_string.length)
end

puts caesar_cipher('What a string!', 5)
