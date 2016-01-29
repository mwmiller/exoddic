defmodule Exoddic.Converter.Prob do
  @behaviour Exoddic.Converter
  @moduledoc """
    Probability
  """

  def from_prob(amount), do: amount

  def to_prob(amount), do: amount

  @doc "Formatted up to 15 decimal places as precision requires."
  def for_display(amount), do: Float.to_string(amount, [decimals: 15, compact: true])

end
