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

  def self.get_domain(url)
    return $1 if url =~ /(\w+[\w-\.]+\.[a-zA-Z]+)/
  end

  def self.get_main_domain(url)
    return $1 if url =~ /([\w-]+\.(com|net|org|gov|cc|biz|info|cn|me|cc|la|tv)(\.(cn|hk|tw|jp))*)(\/|:|$)/
  end

  def self.belong_to_domain(sub_domain, main_domain)
    sub_domain.match(/\.?#{main_domain}$/).present?
  end
end
