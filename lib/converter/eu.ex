defmodule Exoddic.Converter.Eu do
  @behaviour Exoddic.Converter
  @moduledoc """
    .eu-style decimal odds
  """

  def from_prob(amount) when amount == 0, do: 0.0
  def from_prob(amount) when amount != 0, do: 1 / amount

  def to_prob(amount) when amount == 0, do: 0.0
  def to_prob(amount) when amount != 0, do: 1 / amount

  @doc "Formatted to three decimal places"
  def for_display(amount), do: :erlang.float_to_binary(amount, decimals: 3)
end
