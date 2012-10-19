#!/usr/bin/env ruby

class Tape

  def initialize
    @tape = [0]
    @index = 0
  end

  def lshift
    case @index
    when 0
      @tape.unshift 0
    else
      @index -= 1
    end
  end

  def rshift
    if @index == @tape.length - 1
      @tape.push 0
    end

    @index += 1
  end

  def incr
    @tape[@index] += 1
  end

  def decr
    @tape[@index] -= 1
  end

  def input
    @tape[@index] = $stdin.gets(1).to_i
  end

  def output
    $stdout.write(@tape[@index].chr)
  end

  def current_value
    @tape[@index]
  end

end

module CallStack extend self
  def stack
    @stack ||= []
  end

  def current
    stack[-1]
  end

  def <<(other)
    stack << other
  end

  def unwind
    stack.pop
  end
end

def run(code)
  tape = Tape.new
  idx = 0
  last = code.length - 1
  skip = 0
  while idx != last
    # Special case [ when current = 0
    if skip > 0
      case code[idx]
      when "["
        skip += 1
      when "]"
        skip -= 1
      end
      next
    end
    # End special case
    #
    case code[idx]
    when ">"
      tape.rshift
    when "<"
      tape.lshift
    when "+"
      tape.incr
    when "-"
      tape.decr
    when "."
      tape.output
    when ","
      tape.input
    when "["
      if tape.current_value == 0

      else
        CallStack << idx
      end
    when "]"
      if tape.current_value != 0
        idx = CallStack.current
      else
        CallStack.unwind
      end
    end
    idx += 1
  end
end

def main(argv)
  program = []

  argv.each do |file|
    File.open(file).each_char do |c|
      program << c if %w{[ ] , . + - < > }.include? c
    end
    run(program)
  end

end

main(ARGV)
