require 'test_helper'

class InterpreterTest < ActiveSupport::TestCase
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

  test 'Print function prints all parameters un the same line' do
    code = 'print(1, 2, 3)'

    result = Interpreter.interpret(code)
    assert_equal(['1 2 3'], result)
  end
end
