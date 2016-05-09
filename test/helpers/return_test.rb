require 'test_helper'

class ReturnTest < ActiveSupport::TestCase
  test 'Function returns value if called' do
    code = 'fun f does return 1 with none
            print(f())'

    result = Interpreter.interpret(code)
    assert_equal(['1'], result)
  end

  test 'Returned function value is assigned correctly to variable' do
    code = 'fun f does return 1 with none
            a = f()
            print(a)'

    result = Interpreter.interpret(code)
    assert_equal(['1'], result)
  end

  test 'Returned function value can be used in expressions' do
    code = 'fun f does return 3 with none
            a = f() + f()
            a = a * f() - f() / f()
            print(a)'

    result = Interpreter.interpret(code)
    assert_equal(['17'], result)
  end

  test 'Function returns correct value for multiple body nodes' do
    code = 'fun f does
              a = b + 2
              return a
            with b
            print(f(3))'

    result = Interpreter.interpret(code)
    assert_equal(['5'], result)
  end

  test 'Function does not execute code after return' do
    code = 'fun f does
              return
              a = b + 2
              print(a)
            with b
            f(3)'

    result = Interpreter.interpret(code)
    assert_equal([], result)
  end

  test 'Chained function calls return correct value' do
    code = 'fun f does return b + 1 with b
            fun g does return f(b) + 1 with b
            print(g(3))'

    result = Interpreter.interpret(code)
    assert_equal(['5'], result)
  end

  test 'Function return works inside select' do
    code = 'fun f does return b + 1 with b
            fun g does
              select x from 0 to 10 do
                b = b + f(x)
              end
              return b
            with b
            print(g(0))'

    result = Interpreter.interpret(code)
    assert_equal(['66'], result)
  end

  test 'Returning inside select stops execution and returns value' do
    code = 'fun f does
              select x from 5 to 10 do
                return x
                print(x)
              end
            with none
            print(f())'

    result = Interpreter.interpret(code)
    assert_equal(['5'], result)
  end

  test 'Returning inside when clause stops execution and returns value' do
    code = 'fun f does
              when true then
                return "Success!"
                print("Test failed!")
              end
            with none
            print(f())'

    result = Interpreter.interpret(code)
    assert_equal(['"Success!"'], result)
  end

  test 'Returning inside nested select stops execution and returns value' do
    code = 'fun f does
              select x from 5 to 10 do
                select y from 11 to 15 do
                  return y
                  print(y)
                end
                return x
                print(x)
              end
            with none
            print(f())'

    result = Interpreter.interpret(code)
    assert_equal(['11'], result)
  end

  test 'Returning inside nested when clauses stops execution and returns value' do
    code = 'fun f does
              when true then
                when true then
                  return "Nested success!"
                  print("Test failed!")
                end
                return "Success!"
                print("Test failed!")
              end
            with none
            print(f())'

    result = Interpreter.interpret(code)
    assert_equal(['"Nested success!"'], result)
  end
end
