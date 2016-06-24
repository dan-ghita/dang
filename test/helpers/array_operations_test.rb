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

  test 'Array accessor works for nested arrays' do
    code= 'a = [[[[1], [2]]]]
           print(a[0][0][1][0])'

    result = Interpreter.interpret(code)
    assert_equal(['2'], result)
  end

  test 'Array accessor on nested arrays returns arrays' do
    code= 'a = [[[[1], [2]]]]
           print(a[0][0] + [[3], [4]])'

    result = Interpreter.interpret(code)
    assert_equal(['[[1], [2], [3], [4]]'], result)
  end

  test 'Array accessor on strings in array returns string character' do
    code= 'a = [[["abc"]]]
           print(a[0][0][0][1])'

    result = Interpreter.interpret(code)
    assert_equal(['b'], result)
  end

  test 'Accessing integer element from nested array throws error' do
    code= 'a = [[[1]]]
           print(a[0][0][0][1])'

    result = Interpreter.interpret(code)
    assert_equal(["[x] element 1 is not of type Array/String but of type Fixnum"], result)
  end

  test 'Accessing nested array throws error when index out of bounds' do
    code= 'a = [[[1]]]
           print(a[0][0][1])'

    result = Interpreter.interpret(code)
    assert_equal(["[x] index 1 is out of bounds for array [1]"], result)
  end

  test 'Array accessor assignment on nested modifies the array' do
    code= 'a = [[[1]]]
           a[0][0][0] = 2
           print(a)'

    result = Interpreter.interpret(code)
    assert_equal([""], result)
  end
end
