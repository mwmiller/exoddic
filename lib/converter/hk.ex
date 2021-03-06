defmodule Exoddic.Converter.Hk do
  @behaviour Exoddic.Converter
  @moduledoc """
    .hk-style odds
  """

  def from_prob(amount) when amount == 0.00, do: 0.0
  def from_prob(amount) when amount >= 0.50, do: 1 / amount - 1
  def from_prob(amount) when amount < 0.50, do: (1 - amount) / amount

  def to_prob(amount) when amount == 0, do: 0.0
  def to_prob(amount) when amount != 0, do: 1 / (amount + 1)

  @doc "Formatted to three decimal places"
  def for_display(amount), do: :erlang.float_to_binary(amount, decimals: 3)
end
