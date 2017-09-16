def is_palindrome(str)
  res = true
  (str.length / 2).times do |i|
    res = (str[i] == str[-(i+1)])
    break unless res
  end
  res
end

# Gets the largest palindrome in str whose first character is the first
# character of str
def left_palindrome(str)
  # One character strings are palindromes
  res = str[0] || ''
  (str.length - 1).times do |i|
    check = str[0..(-1 - i)]
    if is_palindrome(check)
      res = check
      break
    end
  end
  res
end

# Gets the largest palindrome in str whoe last character is the last
# character of str
def right_palindrome(str)
  # One character strings are palindromes
  res = str[-1] || ''
  (str.length - 1).times do |i|
    check = str[i..-1]
    if is_palindrome(check)
      res = check
      break
    end
  end
  res
end

# Returns the string with the greater length. If they have the same length,
# returns the string that comes first in lexicographical order
# Actually changed to something that can be used in a sort
def max_cmp(x, y)
  if x.length > y.length
    -1
  elsif x.length < y.length
    1
  else
    x <=> y
  end
end

def max(*strs)
  #puts "calling max on #{strs.inspect}"
  # Flatten allows passing an array in as well as a splatted param list
  (strs.flatten.sort { |x,y| max_cmp(x,y) })[0]
end

def palindrome_recurse(x, y, a_match)
  #puts "Recursing on #{x} | #{y} | #{a_match}"
  if !a_match
    # rindex only happens when starting from scratch because characters can be
    # skipped
    if x.empty? || y.empty?
      #puts "x or y is empty and there was no match, returning empty string"
      # Base case
      ''
    elsif (idx = y.rindex(x[0]))
      #puts "Found rindex match on #{idx} of y"
      if idx == 0
        # y needs to be an empty string when recursing now, slicing using the
        # same expression won't yield an empty string
        "#{x[0]}#{palindrome_recurse(x[1..-1], '', true)}#{y[idx]}"
      else
        palins = []
        palins << "#{x[0]}#{palindrome_recurse(x[1..-1], y[0..(idx - 1)], true)}#{y[idx]}"
        # Must also check the same combination for any additional matches of x[0]
        # to the left of the current match in y
        # TODO: Figure out how to trigger this so that it doesn't add to the
        # current solution -- it is generating things that it thinks are
        # substrings but arent
        # Don't know if I actually need this now
        palins << palindrome_recurse(x, y[0..(idx-1)], false)
        max(palins)
      end
    else
      palindrome_recurse(x[1..-1], y, false)
    end
  #elsif a_match
  else
    # There's already been a match so you can't skip over any characters on the ends now
    if x.empty? || y.empty?
      #puts "x or y is empty and there was a match, checking anchors"
      max(left_palindrome(x), right_palindrome(y))
    elsif x[0] == y[-1]
      "#{x[0]}#{palindrome_recurse(x[1..-1], y[0..-2], true)}#{y[-1]}"
    else
      #puts "no match of first char of x and last char of y and there was a match, checking anchors"
      max(left_palindrome(x), right_palindrome(y))
    end
  end
end

def palindrome(x, y)
  palins = []
  (x.length - 1).times do |i|
    palins << palindrome_recurse(x[i..-1], y, false)
  end
  res = max(palins)
  if (res == '' || res == nil) then -1 else res end
end

def solution(instream, outstream)
  instream.gets.chomp.to_i.times do
    str1 = instream.gets.chomp
    str2 = instream.gets.chomp
    outstream.puts palindrome(str1, str2)
  end
end
#solution(File.open('my-testcases-for-run-again.txt', 'r'), STDOUT)
#solution(File.open('input01.txt', 'r'), STDOUT)
solution(STDIN, STDOUT)
