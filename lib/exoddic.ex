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
      { module_from_options(options,:from),
        module_from_options(options, :to),
        Keyword.get(options, :for_display, true)
      }
    end

    @spec module_from_options(exoddic_options, atom) :: atom
    defp module_from_options(options, which) do
        Module.concat([__MODULE__, Converter, Keyword.get(options, which, :prob) |> Atom.to_string |> String.capitalize])
    end

    @doc """
    Convert values among the various supported odds formats.

    Conversion amounts provided as strings will receive a best effort attempt at conversion to
    an appropriate number.
    """
    @spec convert(number | String.t, exoddic_options) :: String.t | float
    def convert(amount, options \\ []) do
      {from_module, to_module, for_display} = parse_options(options)

      final_amount = amount |> normalize |> from_module.to_prob |> to_module.from_prob

      if for_display, do: to_module.for_display(final_amount), else: final_amount
    end

    @spec normalize(number | String.t) :: float
    defp normalize(amount) when is_number(amount), do: amount/1.0   # Guarantee float
    defp normalize(amount) when is_bitstring(amount) do
      captures = Regex.named_captures(~r/^(?<s>[\+-])?(?<n>[\d\.]+)(?<q>[\/:-])?(?<d>[\d\.]+)?(?<p>%)?$/, amount)
      modifier = case captures do
          %{"s" => "-", "p" => "%"} -> -1.0/100.0 # Both sounds crazy
          %{"s" => "-"}             -> -1.0
          %{"p" => "%"}             -> 1/100
          _                         -> 1.0        # Unmodified: covers nil, a "+" sign, etc.
      end

      value = case captures do
          nil                     -> 0.0       # Not even close
          %{"n" => ""}            -> 0.0       # Does not parse a numerator
          %{"q" => "",  "n" => n} -> fparse(n) # No quotient operator, just numerator
          %{"d" => ""}            -> 0.0       # Quotient without denominator, failure
          %{"n" => n, "d" => d}   -> fparse(n)/fparse(d)
      end
      value * modifier
    end

    @spec fparse(String.t) :: float
    defp fparse(str) do
          # We'll just assume we got reasonable stuff
          {x, _remainder} = Float.parse(str)
          x
    end

end
