defmodule Exoddic.Converter.Hk do
  @behaviour Exoddic.Converter
  @moduledoc """
    .hk-style odds
  """

  def from_prob(amount) when amount >= 0.50, do: 1 /amount - 1
  def from_prob(amount) when amount <  0.50, do: (1 - amount)/amount

  def to_prob(amount), do: 1 / (amount + 1)

  @doc "Formatted to three decimal places"
  def for_display(amount), do: Float.to_string(amount, [decimals: 3])

end