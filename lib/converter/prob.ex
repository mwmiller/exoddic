defmodule Exoddic.Converter.Prob do
  @behaviour Exoddic.Converter
  @moduledoc """
    Probability
  """

  def from_prob(amount), do: amount

  def to_prob(amount), do: amount

  @doc "Formatted as an integer percentage"
  def for_display(amount), do: "#{round(amount*100)}%"

end
