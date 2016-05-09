require 'test_helper'

class ArrayOperationsTest < ActiveSupport::TestCase
  test 'Array accessor returns correct value' do
    code = 'a = [1, 2, 3]
            b = a[0]
            print(b)'

    result = Interpreter.interpret(code)
    assert_equal(['1'], result)
  end

  test 'Array accessor is printed' do
    code = 'a = [1, 2, 3]
            print(a[0])'

    result = Interpreter.interpret(code)
    assert_equal(['1'], result)
  end

  test 'Array accessor in expression right operand' do
    code = 'a = [1, 2, 3]
            b = 1 + a[0]
            b = 1 * a[0] + b
            print(b)'

    result = Interpreter.interpret(code)
    assert_equal(['3'], result)
  end

  test 'Array accessor in expression left operand' do
    code = 'a = [1, 2, 3]
            b = a[0] + 1
            b = a[0] * 1 + b
            print(b)'

    result = Interpreter.interpret(code)
    assert_equal(['3'], result)
  end

  test 'Array accessor assignment modifies array' do
    code = 'a = [1, 2, 3]
            a[0] = 2
            print(a[0])
            print(a)'

    result = Interpreter.interpret(code)
    assert_equal(['2', '[2, 2, 3]'], result)
  end

  test 'Appending to array modifies content' do
    code= 'a = [1, 2, 3]
           a.append(4)
           print(a)'

    result = Interpreter.interpret(code)
    assert_equal(['[1, 2, 3, 4]'], result)
  end

  test 'Appending multiple elements to array modifies content' do
    code= 'a = [1, 2, 3]
           a.append(4, 5, 6)
           print(a)'

    result = Interpreter.interpret(code)
    assert_equal(['[1, 2, 3, 4, 5, 6]'], result)
  end

  test 'Appending to number throws error' do
    code= 'a = 1
           a.append(2)
           print(a)'

    result = Interpreter.interpret(code)
    assert_equal(["[x] Method append can't be called for object a(Fixnum)"], result)
  end

  test 'Deleting multiple elements from array modifies content' do
    code= 'a = [1, 2, 3, 4, 4]
           a.delete(3, 4)
           print(a)'

    result = Interpreter.interpret(code)
    assert_equal(['[1, 2]'], result)
  end

  test 'Deleting from number throws error' do
    code= 'a = 1
           a.delete(2)
           print(a)'

    result = Interpreter.interpret(code)
    assert_equal(["[x] Method delete can't be called for object a(Fixnum)"], result)
  end

  test 'Array identifier concatenation produces expected result' do
    code= 'a = [1]
           b = [2]
           c = a + b
           print(c)'

    result = Interpreter.interpret(code)
    assert_equal(['[1, 2]'], result)
  end

  test 'Array concatenation produces expected result' do
    code= 'a = [1] + [2]
           print(a)'

    result = Interpreter.interpret(code)
    assert_equal(['[1, 2]'], result)
  end

  test 'Print function prints all parameters on the same line' do
    code = 'print(1, 2, 3)'

    result = Interpreter.interpret(code)
    assert_equal(['1 2 3'], result)
  end
end
