# https://www.hackerrank.com/challenges/challenging-palindromes

class String
  def substrings(size)
    res = []
    self.length.times do |i|
      sstr = self[i, size]
      res << sstr unless sstr.length != size
    end
    res
  end
end

# Gets all of the largest palindromes that can be created from substrings
# of the two provided strings
def palindrome(str1, str2)
  pdrome = nil

  # Use the first string for generating substrings, search for those
  # substrings inside the second string

  sstrSize = str1.length
  while sstrSize > 0
    sstrs = str1.substrings(sstrSize)

    sstrs.each do |sstr|
      sstrRev = sstr.reverse
      str1Pattern = /#{sstr}(\w*)/
      str2Pattern = /(\w*)#{sstrRev}/

      # This match will pick up the empty string as a match
      if (beforeStr2 = str2.match(str2Pattern))


        # Find the greatest palindrome that comes before the reverse substring
        # match
        beforePdrome = beforeStr2[1]
        beforePdrome.length.times do
          beforePdrome = beforePdrome[1..-1]
          break if is_palindrome(beforePdrome)
        end

        afterStr1 = str1.match(str1Pattern)
        afterPdrome = afterStr1[1]
        afterPdrome.length.times do
          afterPdrome = afterPdrome[0..-2]
          break if is_palindrome(afterPdrome)
        end

        if afterPdrome.length < beforePdrome.length
          pdrome = "#{sstr}#{beforePdrome}#{sstrRev}"
        elsif afterPdrome.length > beforePdrome.length
          pdrome = "#{sstr}#{afterPdrome}#{sstrRev}"
        else
          # Pick palindrome that will come first
          comp = (afterPdrome <=> beforePdrome)
          if comp < 0
            pdrome = "#{sstr}#{afterPdrome}#{sstrRev}"
          else
            pdrome = "#{sstr}#{beforePdrome}#{sstrRev}"
          end
        end
      end
      break if pdrome
    end

    break if pdrome
    sstrSize -= 1
  end
  pdrome
end

def is_palindrome(str)
  res = true
  (str.length / 2).times do |i|
    res = (str[i] == str[-(i+1)])
    break unless res
  end
  res
end

def final_palindrome(str1, str2)
  palindrome(str1, str2)
end

def solution(instream, outstream)
  instream.gets.chomp.to_i.times do
    str1 = instream.gets.chomp
    str2 = instream.gets.chomp
    outstream.puts final_palindrome(str1, str2)
  end
end
solution(File.open('input01.txt', 'r'), STDOUT)
