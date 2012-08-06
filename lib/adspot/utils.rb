require 'digest/sha1' 

module Utils
  def self.create_random_code(length)
    return '' unless (1..10).cover? length

    arr = (0..9).to_a + ('A'..'Z').to_a
    str = ''
    length.times.map do
      i = rand arr.length
      str += arr[i].to_s
    end
    return str
  end

  def self.sha1(str)
    Digest::SHA1.hexdigest(str)
  end
  
end
