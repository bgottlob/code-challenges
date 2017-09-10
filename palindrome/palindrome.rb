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
  palindromes = []
  if str1.length < str2.length
    rootStr = str1
    searchStr = str2
  else
    rootStr = str2
    searchStr = str1
  end

  # Use the root (the shorter one) for generating substrings, search for those
  # substrings inside the search string

  sstrSize = rootStr.length
  while sstrSize > 0

    sstrs = rootStr.substrings(sstrSize)
    # Search for palindromes with even length, since they will be longer than
    # odd ones
    sstrs.each do |sstr|
      sstrRev = sstr.reverse
      searchPattern = /(\w)?#{sstrRev}(\w)?/
      rootPattern = /(\w)?#{sstr}(\w)?/
      # Check if there is at least one occurrence of the substring in the
      # search string and pluck out the individual characters surrounding the
      # matches for use as the middle character of an odd length palindrome
      unless (surroundSearch = searchStr.scan(searchPattern)).empty?

        surroundSearch.each do |pair|
          # pair[0] is char that comes before reversed substring in search str
          palindromes << "#{sstr}#{pair[0]}#{sstrRev}" if pair[0]
          # pair[1] comes after
          palindromes << "#{sstrRev}#{pair[1]}#{sstr}" if pair[1]
        end

        rootStr.scan(rootPattern).each do |pair|
          # pair[0] is char that comes before not-reversed substring in root str
          palindromes << "#{sstrRev}#{pair[0]}#{sstr}" if pair[0]
          # pair[1] comes after
          palindromes << "#{sstr}#{pair[1]}#{sstrRev}" if pair[1]
        end


        ## Filter out nils
        #surround.select { |char| !!char }.each do |char|
        #  # The problem needs the palindrome that comes first in alphabetical
        #  # order; the two palindromes could be compared here and the later one
        #  # trashed to shorten the list size to sort later
        #  palindromes << "#{sstr}#{char}#{sstrRev}"
        #  palindromes << "#{sstrRev}#{char}#{sstr}"
        #end
        if palindromes.empty?
          palindromes << "#{sstr}#{sstrRev}"
          palindromes << "#{sstrRev}#{sstr}"
        end
      end
    end

    break unless palindromes.empty?

    sstrSize -= 1
  end
  palindromes
end

def final_palindrome(str1, str2)
  all = palindrome(str1, str2)
  if all.empty?
    -1
  else
    all.sort(&:<=>)[0]
  end
end

def solution(instream, outstream)
  instream.gets.chomp.to_i.times do
    str1 = instream.gets.chomp
    str2 = instream.gets.chomp
    outstream.puts final_palindrome(str1, str2)
  end
end

solution(STDIN, STDOUT)
