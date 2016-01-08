# Exoddic

Simple odds conversion (and, perhaps, future additional handling)

Currently supports the following formats:

- :prob implied probability
- :us US-style moneyline odds
- :uk UK-style traditional odds
- :eu Euro-style decimal odds
- :id Indonesian-style odds
- :my Malaysian-style odds
- :hk Hong Kong-style odds

## Example usage

```
Exoddic.convert(0.50, from: :prob, to: :us, for_display: true) # "+100"
Exoddic.convert("2/1", from: :uk, to: :eu, for_display: true)  # "3.000"
Exoddic.convert(4.0, from: :eu, to: :prob, for_display: false) # 0.25
```
