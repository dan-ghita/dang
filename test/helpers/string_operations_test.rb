require 'test_helper'

class StringOperationsTest < ActiveSupport::TestCase
  test 'String is printed correctly after definition' do
    code = 's = "a  b   c"
                print(s)'

    result = Interpreter.interpret(code)
    assert_equal(['a  b   c'], result)
  end

  test 'String accessor returns correct value' do
    code = 'a = "abc"
            b = a[0]
            print(b)'

    result = Interpreter.interpret(code)
    assert_equal(['a'], result)
  end

  test 'String assignment modifies string' do
    code = 'a = "abc"
            a[0] = "b"
            print(a)'

    result = Interpreter.interpret(code)
    assert_equal(['bbc'], result)
  end

  test 'Using [] operator on int throws error' do
    code = 'a = 1
            print(a[0])'

    result = Interpreter.interpret(code)
    assert_equal(['[x] identifier a is not of type Array/String but of type Fixnum'], result)
  end

  test 'String identifier concatenation produces expected result' do
    code = 'a = "a"
            b = "b"
            c = a + b
            print(c)'

    result = Interpreter.interpret(code)
    assert_equal(['ab'], result)
  end

  test 'String concatenation produces expected result' do
    code = 'a = "1" + "2"
            print(a)'

    result = Interpreter.interpret(code)
    assert_equal(['12'], result)
  end
end
