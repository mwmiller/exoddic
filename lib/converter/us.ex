defmodule Exoddic.Converter.Us do
  @behaviour Exoddic.Converter
  @moduledoc """
    .us-style moneyline odds
  """

  def from_prob(amount) when amount == 0.00, do: 0.0
  def from_prob(amount) when amount <= 0.50, do: 100 * ((1 - amount) / amount)
  def from_prob(amount) when amount > 0.50, do: -100 * (amount / (1 - amount))

  def to_prob(amount) when amount == 0, do: 0.0
  def to_prob(amount) when amount < 0, do: amount / (amount - 100)
  def to_prob(amount) when amount > 0, do: 100 / (amount + 100)

  @doc "Nearest integer; includes prepended '+' for non-negative"
  def for_display(amount) when amount < 0, do: "#{round(amount)}"
  def for_display(amount) when amount >= 0, do: "+#{round(amount)}"
end
