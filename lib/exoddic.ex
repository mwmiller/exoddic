defmodule Exoddic do
    @moduledoc """
    A means for working with odds and probability.

    In particular, a means to convert between different representations.
    """
    @typedoc """
    A keyword list with conversion options

    - `from`: the supplied format
    - `to`: the desired format
    - `for_display`: whether to nicely format the output as a string

    """
    @type exoddic_options :: [from: atom, to: atom, for_display: boolean]
    @doc """
    convert values among the various supported odds formats.

    The `to` and `from` formats are identified by atoms corresponding to
    the converter module names.

    Conversion amounts provided as strings will receive a best effort attempt at conversion to
    an appropriate number.

    `for_display` defaults to true and will return an appropriately formatted string for the
    requested item.  If set to false, it will return an unformatted number.
    """
    @spec convert(number | String.t, exoddic_options) :: String.t | number
    def convert(amount, options \\ []) do
      num_amount  = if is_bitstring(amount), do: destring(amount), else: amount
      {from_module, to_module, for_display} = parse_options(options)

      final_amount = num_amount |> from_module.to_prob |> to_module.from_prob

      if for_display, do: to_module.for_display(final_amount), else: final_amount
    end

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

    @spec destring(String.t) :: float
    defp destring(maybe_num) do
      num = cond do
          Regex.match?(~r/^[0-9\/+-\.]+$/, maybe_num) -> Code.eval_string(maybe_num) |> (fn({x,_}) -> x end).()
          Regex.match?(~r/^[0-9\/\.]+%$/, maybe_num)  -> String.strip(maybe_num,?%) |> Float.parse |> (fn({x,_}) -> x/100 end).()
          true                                        -> 0.0  # It's an error, but we're not doing anything about it at present
      end
      num / 1.0
    end

end
