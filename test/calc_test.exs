defmodule CalcTest do
  use ExUnit.Case
  doctest Calc

  test "Test Basic Operations" do
    assert Calc.eval("5 + 4") == 9
    assert Calc.eval("5 * 4") == 20
    assert Calc.eval("8 / 2") == 4
    assert Calc.eval("5 - 4") == 1
  end

  test "Test Order of Operations" do
    assert Calc.eval("24 / 6 + (5 - 4)") == 5
    assert Calc.eval("1 + 3 * 3 + 1") == 11
    assert Calc.eval("(1 + 3) * 3 + 1") == 13
    assert Calc.eval("((1 - 3) * 2) * 3 + 1") == -11
  end
end
