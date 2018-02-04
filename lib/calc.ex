defmodule Calc do
  @moduledoc """
  Documentation for Calc.
  """

  def main() do
    IO.gets("> ")
    |> eval()
    |> IO.inspect
    main()
  end

  def eval(expression) do
    expression
    |> String.trim
    |> String.replace("(", "( ")
    |> String.replace(")", " )") 
    |> String.split
    |> Enum.map(fn(x) -> convert(x) end)
    |> postfix([], [])
    |> my_flatten
    |> calc
  end


  defp number?(x) do
    non_digits = ["(", ")", "+", "-", "*", "/"]
    not Enum.member?(non_digits, x)
  end

  defp operand?(x) do
    operands = ["+", "-", "*", "/"]
    Enum.member?(operands, x)
  end 
      
  defp convert(x) do
    if number?(x) do
      String.to_integer(x)
    else
      x
    end
  end

  defp calc(expression) do
     evaluate(expression, [])
  end

  defp evaluate([], [h | _t]), do: h

  defp evaluate(["+" | t], [y, x | s]) do
    evaluate(t, [x + y | s])
  end

  defp evaluate(["*" | t], [y, x | s]) do
    evaluate(t, [x * y | s])
  end

  defp evaluate(["-" | t], [y, x | s]) do
    evaluate(t, [x - y | s])
  end

  defp evaluate(["/" | t], [y, x | s]) do
    evaluate(t, [div(x, y) | s])
  end

  defp evaluate([h | t], stack), do: evaluate(t, [h | stack])

  defp my_flatten([h | t]), do: my_flatten(h) ++ my_flatten(t)
  defp my_flatten([]), do: []
  defp my_flatten(x), do: [x]

  #The following code is used to convert infix notation to postfix notation.
  #The code is based on the algorithm implemented by Jayesh Chandrapal in Python.
  #http://rextester.com/OOWRE88902
  
  defp push(stack, value) do
    [value] ++ stack
  end 

  defp pop(stack) do
    List.pop_at(stack, 0)
  end

  defp empty?(stack) do
    Enum.count(stack) == 0
  end

  @order_of_operations %{"*" => 3, "/" => 3, "+" => 2, "-" => 2, "(" => 1}

  defp postfix([], operations, list) do
     list = List.flatten(list)
     operations = List.flatten(operations)
     operation(operations, list)
  end

  defp postfix(expression, operations, list) when is_integer(hd(expression)) do
    postfix(tl(expression), operations, list ++[hd(expression)]) 
  end

  defp postfix(expression, operations, list) do
    [h | t] = expression
    {first, rest} = pop(operations)  
      cond do
        h == "(" -> postfix(t, push(operations, h), list)
        h == ")" and first != "(" -> postfix(expression, rest, list ++[first])
        h == ")" and first == "(" -> postfix(t, rest, list)
        operand?(h) and not empty?(operations) and @order_of_operations[first] >= @order_of_operations[h] -> postfix(expression, rest, list ++[first])
        operand?(h) -> postfix(t, push(operations, h), list)
    end
  end

  defp operation([], list), do: list

  defp operation(operations, list) do
    operation(tl(operations), list ++ hd(operations))
  end
 
end
