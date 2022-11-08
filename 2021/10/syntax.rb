PUNCTUATION = {
  "(" => ")",
  "[" => "]",
  "{" => "}",
  "<" => ">"
}

CORRUPT_SCORES = {
  ")" => 3,
  "]" => 57,
  "}" => 1197,
  ">" => 25137
}

INCOMPLETE_SCORES = {
  ")" => 1,
  "]" => 2,
  "}" => 3,
  ">" => 4
}

def middle_index(arr)
  arr.sort[(arr.length) / 2]
end

def corrupt?(bad_chars)
  bad_chars.is_a?(String)
end

def find_corrupt_char(line)
  running_chars = []
  line.each_with_index do |chr, i|
    if PUNCTUATION.keys.include?(chr)
      running_chars << chr
    else
      last_char = running_chars.pop
      return chr if last_char != PUNCTUATION.key(chr)
    end
  end
  running_chars
end

syntax = File.read('data.txt').split.map { |str| str.chars }

corrupt_score = 0
line_scores = []
syntax.each_with_index do |line, i|
  error_chars = find_corrupt_char(line)
  if corrupt?(error_chars)
    corrupt_score += CORRUPT_SCORES[error_chars]
  else
    error_chars.map! { |chr| PUNCTUATION[chr] }
    incomplete_score = 0
    error_chars.reverse.each do |chr|
      incomplete_score *= 5
      incomplete_score += INCOMPLETE_SCORES[chr]
    end
    line_scores << incomplete_score
  end 
end
p "corrupt score: #{corrupt_score}"
p "middle incompletion score: #{middle_index(line_scores)}"

