defmodule Exoddic do
    @moduledoc """
    This module provides a means for working with odds and probability. In
    particular, it provides a means to convert between different representations.
    """
    # Should figure out how to enumerate the supported atoms
    @doc """
    convert values among the various provided odds formats.

    The `to` and `from` formats are identified by atoms as described below:

    - `:prob` is the implied probability.  Formatted as precisely as possible.
    - `:us` is American-style "moneyline odds". Formatted to the nearest integer.
    - `:uk` is UK-style "traditional odds". Formatted as an integer ratio, with a denominator up to 1000.
    - `:eu` is European-style "decimal odds". Formatted to three decimal places.
    - `:id` is Indonesian-style odds. Formatted to three decimal places.
    - `:my` is Malaysian-style odds. Formatted to three decimal places.
    - `:hk` is Hong Kong-style odds. Formatted to three decimal places.

    Conversion amounts provided as strings will receive a best effort attempt at conversion to
    an appropriate number.  Care should be taken to provide the appropriate number format for
    the chosen `from`.  Converting `to` and `from` the same format with an appropriate `for_display`
    setting should provide insight into the conversion formats.

    `for_display` defaults to true and will return an appropriately formatted string for the
    requested item.  If set to false, it will return an unformatted number.
    """
    @spec convert(number | String.t, [from: atom, to: atom, for_display: boolean]) :: String.t | number
    def convert(amount, options \\ []) do
      num_amount = destring(amount)
      from = Keyword.get(options, :from, :prob)
      to = Keyword.get(options, :to, :prob)
      for_display = Keyword.get(options, :for_display, true)

      final_amount = cond do
          to == from -> num_amount
          to != :prob and from != :prob -> conv(num_amount, :prob, from) |> conv(to, :prob)
          true -> conv(num_amount, to, from)
      end
      if for_display, do: make_string(final_amount, to), else: final_amount
    end

    defp make_string(amount, to) do
        case to do
            :prob -> prob_display(amount)
            :eu   -> float_odds_display(amount)
            :id   -> float_odds_display(amount)
            :my   -> float_odds_display(amount)
            :hk   -> float_odds_display(amount)
            :us   -> if amount > 0, do: "+#{amount}", else: "#{amount}"
            :uk   -> format_fraction(amount, 1000)
        end
    end

    defp destring(maybe_num) do
      {num_amount, _} = if is_bitstring(maybe_num) and Regex.match?(~r/^[0-9\/+-\.]+$/, maybe_num), do: Code.eval_string(maybe_num), else: {maybe_num, :ok}
      num_amount
    end

    defp float_odds_display(num), do: Float.to_string(num, [decimals: 3])
    defp prob_display(num), do: Float.to_string(num, [decimals: 15, compact: true])
    defp format_fraction(number,biggest) do
      num = number * biggest |> round
      denom = gcd(num,biggest)
      "#{Float.to_string(num/denom, [decimals: 0])}/#{Float.to_string(biggest/denom, [decimals: 0])}"
    end

    # To resolve fractionals as closely as possible for now.
    defp gcd(a,0), do: a
    defp gcd(a,b), do: gcd(b,rem(a,b))

    # european/decimal
    defp conv(amount, :eu, :prob), do: (1/amount)
    defp conv(amount, :prob, :eu), do: (1/amount)
    # american/moneyline
    defp conv(amount, :us, :prob) when amount <= 0.50, do: round(100 * ((1 - amount)/amount))
    defp conv(amount, :us, :prob) when amount > 0.50, do: round(-100 * (amount / (1 - amount)))
    defp conv(amount, :prob, :us) when amount < 0, do: amount / (amount - 100)
    defp conv(amount, :prob, :us) when amount >= 0, do: 100/ (amount + 100)
    # asian varieties
    defp conv(amount, :id, :prob) when amount < 0.50, do: (1 - amount)/amount
    defp conv(amount, :id, :prob) when amount >= 0.50, do: -1 * (amount / (1 - amount))
    defp conv(amount, :prob, :id) when amount < 0, do: amount / (amount - 1)
    defp conv(amount, :prob, :id) when amount >= 0, do: 1 / (amount + 1)
    defp conv(amount, :my, :prob) when amount < 0.50, do: -1 * amount / (1 - amount)
    defp conv(amount, :my, :prob) when amount >= 0.50, do: 1 /amount - 1
    defp conv(amount, :prob, :my) when amount < 0, do: amount / (amount - 1)
    defp conv(amount, :prob, :my) when amount >= 0, do: 1/(amount + 1)
    defp conv(amount, :hk, :prob) when amount >= 0.50, do: conv(amount, :my, :prob)
    defp conv(amount, :hk, :prob) when amount < 0.50, do: conv(amount, :id, :prob)
    defp conv(amount, :prob, :hk) when amount <= 1, do:  conv(amount, :prob, :my)
    defp conv(amount, :prob, :hk) when amount > 1, do: conv(amount, :prob, :id)
    # uk/traditional
    defp conv(amount, :uk, :prob), do: conv(amount, :eu, :prob) - 1
    defp conv(amount, :prob, :uk), do: conv(amount+1, :prob, :eu)

end
