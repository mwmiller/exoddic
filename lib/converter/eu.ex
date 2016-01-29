defmodule Exoddic.Converter.Eu do
  @behaviour Exoddic.Converter
  @moduledoc """
    .eu-style decimal odds
  """

  def from_prob(amount), do: 1/amount

  def to_prob(amount), do: 1/amount

  @doc "Formatted to three decimal places"
  def for_display(amount), do: Float.to_string(amount, [decimals: 3])

end
