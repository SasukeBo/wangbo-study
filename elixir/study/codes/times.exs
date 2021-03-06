defmodule Times do
  def double(n) do
    n * 2
  end

  def triple(n) do
    n * n * n
  end

  def quadruple(n), do: Times.double(Times.double(n))
end
