defmodule Exoddic.Converter.Uk do
  @behaviour Exoddic.Converter
  @moduledoc """
    .uk-style traditional odds
  """

  def from_prob(amount) when amount == 0, do: 0.0
  def from_prob(amount) when amount != 0, do: 1 / amount - 1

  def to_prob(amount) when amount == 0, do: 0.0
  def to_prob(amount) when amount != 0, do: 1 / (amount + 1)

  @doc "Formatted as the nearest integer ratio with a denominator not larger than 1000"
  def for_display(amount) do
    biggest = 1000
    num = round(amount * biggest)
    denom = gcd(num, biggest)

    "#{:erlang.float_to_binary(num / denom, decimals: 0)}/#{
      :erlang.float_to_binary(biggest / denom, decimals: 0)
    }"
  end

  defp gcd(a, 0), do: a
  defp gcd(a, b), do: gcd(b, rem(a, b))
end
