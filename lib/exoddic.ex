defmodule Exoddic do
  @moduledoc """
  A means for working with odds and probability.

  In particular, a means to convert between different representations.
  """
  @typedoc """
  A keyword list with conversion options

  The `to` and `from` formats are identified by atoms corresponding to
  the converter module names. They default to `:prob`

  - `from`: the supplied input format
  - `to`: the desired output format
  - `for_display`: whether to nicely format the output as a string, defaults to `true`

  """
  @type exoddic_options :: [from: atom, to: atom, for_display: boolean]

  @spec parse_options(exoddic_options) :: {atom, atom, boolean}
  defp parse_options(options) do
    {module_from_options(options, :from), module_from_options(options, :to),
     Keyword.get(options, :for_display, true)}
  end

  @spec module_from_options(exoddic_options, atom) :: atom
  defp module_from_options(options, which) do
    Module.concat([
      __MODULE__,
      Converter,
      options |> Keyword.get(which, :prob) |> Atom.to_string() |> String.capitalize()
    ])
  end

  @doc """
  Convert values among the various supported odds formats.

  Conversion amounts provided as strings will receive a best effort attempt at conversion to
  an appropriate number.
  """
  @spec convert(number | String.t(), exoddic_options) :: String.t() | float
  def convert(amount, options \\ []) do
    {from_module, to_module, for_display} = parse_options(options)

    final_amount = amount |> normalize |> from_module.to_prob |> to_module.from_prob

    if for_display, do: to_module.for_display(final_amount), else: final_amount
  end

  @spec normalize(number | String.t()) :: float
  # Guarantee float
  defp normalize(amount) when is_number(amount), do: amount / 1.0

  defp normalize(amount) when is_bitstring(amount) do
    captures =
      Regex.named_captures(
        ~r/^(?<s>[\+-])?(?<n>[\d\.]+)(?<q>[\/:-])?(?<d>[\d\.]+)?(?<p>%)?$/,
        amount
      )

    value_from_captures(captures) * modifier_from_captures(captures)
  end

  defp modifier_from_captures(cap) do
    case cap do
      # Both sounds crazy
      %{"s" => "-", "p" => "%"} ->
        -1.0 / 100.0

      %{"s" => "-"} ->
        -1.0

      %{"p" => "%"} ->
        1 / 100

      # Unmodified: covers nil, a "+" sign, etc.
      _ ->
        1.0
    end
  end

  defp value_from_captures(cap) do
    case cap do
      # Not even close
      nil ->
        0.0

      # Does not parse a numerator
      %{"n" => ""} ->
        0.0

      # No quotient operator, just numerator
      %{"q" => "", "n" => n} ->
        fparse(n)

      # Quotient without denominator, failure
      %{"d" => ""} ->
        0.0

      %{"n" => n, "d" => d} ->
        fparse(n) / fparse(d)
    end
  end

  @spec fparse(String.t()) :: float
  # This should be reasonable given how we parsed the above.
  defp fparse(str), do: str |> Float.parse() |> elem(0)
end
