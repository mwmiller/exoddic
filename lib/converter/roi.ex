defmodule Exoddic.Converter.Roi do
  @behaviour Exoddic.Converter
  @moduledoc """
    Per-unit return on investment
  """

  def from_prob(amount) when amount == 0, do: 0.0
  def from_prob(amount) when amount != 0, do: (1/amount) - 1

  def to_prob(amount) when amount == 0, do: 0.0
  def to_prob(amount) when amount != 0, do: 1/(amount+1);

  @doc "Formatted as an integer percentage"
  def for_display(amount), do: "#{round(amount*100)}%"

end
