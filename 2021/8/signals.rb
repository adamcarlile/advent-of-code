signal_data = File.read('data.txt').gsub!("|", " ").split.each_slice(14).to_a
signal_hash = signal_data.map { |data| [data.take(10), data.drop(10)] }.to_h

# part 1

easy_digit_count = {1 => 0, 4 => 0, 7 => 0, 8 => 0}
output_values = signal_hash.values.flatten
output_values.each do |output|
  length = output.length
  case length
  when 2 then easy_digit_count[1] += 1
  when 3 then easy_digit_count[7] += 1
  when 4 then easy_digit_count[4] += 1
  when 7 then easy_digit_count[8] += 1
  end
end
p easy_digit_count.values.inject(:+)

# part 2

# The deduction process:
# First we identify segment a. This must be the character that the 3-character string has but the 2-character string does not.
# We then notice that we can identify segments b, c, e, and f as each is used in a unique number of the 10 digits:
# segment a appears in 8 digits
# segment b appears in 6 digits
# segment c appears in 8 digits (and we already know a)
# segment d appears in 7 digits
# segment e appears in 4 digits
# segment f appears in 9 digits
# segment g appears in 7 digits
# Now that we know b, c, and f we can identify d, it is the unaccounted-for character in the 4-character string
# And since we know a, b, c, d, e, and f, we know the last character corresponds to g.

DIGIT_SEGMENTS = {
  0 => "abcefg",
  1 => "cf",
  2 => "acdeg",
  3 => "acdfg",
  4 => "bcdf",
  5 => "abdfg",
  6 => "abdefg",
  7 => "acf",
  8 => "abcdefg",
  9 => "abcdfg"
}

def deduce_segment_mapping(signals)
  segment_mapping = {a: nil, b: nil, c: nil, d: nil, e: nil, f: nil, g: nil}
  one_pattern = signals.select { |pattern| pattern.length == 2}[0]
  seven_pattern = signals.select { |pattern| pattern.length == 3}[0]
  four_pattern = signals.select { |pattern| pattern.length == 4}[0]
  segment_mapping[:a] = (seven_pattern.chars - one_pattern.chars)[0]
  all_characters = signals.join
  ("a".."g").each do |letter|
    if all_characters.count(letter) == 4
      segment_mapping[:e] = letter
    elsif all_characters.count(letter) == 6
      segment_mapping[:b] = letter
    elsif all_characters.count(letter) == 8 && segment_mapping[:a] != letter
      segment_mapping[:c] = letter
    elsif all_characters.count(letter) == 9
      segment_mapping[:f] = letter
    end
  end
  segment_mapping[:d] = four_pattern.chars.reject { |letter| segment_mapping.values.include?(letter) }[0]
  segment_mapping[:g] = ("a".."g").reject { |letter| segment_mapping.values.include?(letter) }[0]
  segment_mapping
end

def decode_output(output, segment_mapping)
  decoded_segments = output.chars.map { |letter| segment_mapping.key(letter).to_s }.sort.join
  DIGIT_SEGMENTS.key(decoded_segments)
end

output_numbers = []
signal_hash.each do |signals, output|
  segment_mapping = deduce_segment_mapping(signals)
  output_numbers << output.map { |output_chars| decode_output(output_chars, segment_mapping) }.join.to_i
end
p output_numbers.inject(:+)