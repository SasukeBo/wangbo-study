defmodule MyStrings do
  def is_ASCII([head | tail]) when is_list [head | tail] do
    if head > ?\s - 1 && head < ?~ + 1 do
      is_ASCII(tail)
    else
      false
    end
  end

  def is_ASCII([]), do: true

  def anagram?(word1) do
    Enum.reverse(word1) == word1
  end

  def calculate(expression) when is_list expression do
    analyze(expression, 0)
  end

  defp analyze([head | tail], value) when (head >= ?0 and head <= ?9) do
    analyze(tail, value * 10 + (head - ?0))
  end
  defp analyze([head | tail], value) when head == ?+ do
    value + analyze(tail, 0)
  end
  defp analyze([head | tail], value) when head == ?- do
    value - analyze(tail, 0)
  end
  defp analyze([head | tail], value) when head == ?* do
    value * analyze(tail, 0)
  end
  defp analyze([head | tail], value) when head == ?/ do
    value / analyze(tail, 0)
  end
  defp analyze([head | tail], value) when head == ?\s do
    analyze(tail, value)
  end
  defp analyze([], value), do: value
end
