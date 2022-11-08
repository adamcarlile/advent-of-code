@version = 0

def parse_packet(packet)
  packet_version = packet.shift(3).join.to_i(2)
  @version += packet_version
  type_id = packet.shift(3).join.to_i(2)

  if type_id == 4 # literal packet
    msg = []
    while packet.shift == "1"
      msg.append(*packet.shift(4))
    end
    msg.append(*packet.shift(4))
    return [msg.join.to_i(2), packet]

  else # operator

    # length type == bits
    if packet.shift == "0"
      packet_len = packet.shift(15).join.to_i(2)
      sub_packet = packet.shift(packet_len)
      result = []
      until sub_packet.empty?
        sub_result, sub_packet = parse_packet(sub_packet)
        result << sub_result
      end

    # length type == packet count
    else
      packet_count = packet.shift(11).join.to_i(2)
      result = []
      packet_count.times do
        sub_result, packet = parse_packet(packet)
        result << sub_result
      end
    end

    case type_id
    when 0; return [result.sum, packet]
    when 1; return [result.reduce(&:*), packet]
    when 2; return [result.min, packet]
    when 3; return [result.max, packet]
    when 5; return [result.reduce(&:>) ? 1 : 0, packet]
    when 6; return [result.reduce(&:<) ? 1 : 0, packet]
    when 7; return [result.reduce(&:==) ? 1 : 0, packet]
    end
  end
end

input = File.read("data.txt").strip.chars.map{|c| c.hex.to_s(2).rjust(4, "0").chars}.flatten

puts "Part 2: #{parse_packet(input).first}"
puts "Part 1: #{@version}"
