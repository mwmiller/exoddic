defmodule ExoddicTest do
  use ExUnit.Case
  import Exoddic
  doctest Exoddic

  test "defaults and options" do
    assert convert("50.50%") == "51%", ":prob to :prob for display"
    assert convert("50.50%", for_display: false) == 0.5050, ":prob to :prob not for display"
    assert convert(0.50, to: :us) == "+100", ":prob to :us for display"
    assert convert(0.50, to: :us, for_display: false) == 100, ":prob to :us not for display"
    assert convert("+400", from: :us) == "20%", ":us to :prob for display"
    assert convert("+400", from: :us, for_display: false) == 0.2, ":us to :prob not for display"
    assert convert("+400", from: :us, to: :uk) == "4/1", ":us to :uk for display"

    assert convert("+400", from: :us, to: :uk, for_display: false) == 4,
           ":us to :uk not for display"
  end

  test "to probability - even money" do
    assert convert("+100", from: :us, to: :prob) == "50%", "US"
    assert convert(2.0, from: :eu, to: :prob) == "50%", "EU"
    assert convert("1-1", from: :uk, to: :prob) == "50%", "UK"
    assert convert(-1.00, from: :id, to: :prob) == "50%", "ID"
    assert convert(1.00, from: :my, to: :prob) == "50%", "MY"
    assert convert(1.00, from: :hk, to: :prob) == "50%", "HK"
    assert convert(1.0, from: :roi, to: :prob) == "50%", "ROI"
  end

  test "from probability - even money" do
    assert convert(0.50, from: :prob, to: :us) == "+100", "US"
    assert convert(0.50, from: :prob, to: :eu) == "2.000", "EU"
    assert convert(0.50, from: :prob, to: :uk) == "1/1", "UK"
    assert convert(0.50, from: :prob, to: :id) == "-1.000", "ID"
    assert convert(0.50, from: :prob, to: :my) == "1.000", "MY"
    assert convert(0.50, from: :prob, to: :hk) == "1.000", "HK"
    assert convert(0.50, from: :prob, to: :roi) == "100%", "ROI"
  end

  test "to probability - out of the money" do
    assert convert("+400", from: :us, to: :prob) == "20%", "US"
    assert convert(5.0, from: :eu, to: :prob) == "20%", "EU"
    assert convert("4:1", from: :uk, to: :prob) == "20%", "UK"
    assert convert(4.00, from: :id, to: :prob) == "20%", "ID"
    assert convert(-0.25, from: :my, to: :prob) == "20%", "MY"
    assert convert(4.00, from: :hk, to: :prob) == "20%", "HK"
    assert convert("400%", from: :roi, to: :prob) == "20%", "ROI"
  end

  test "from probability - out of the money" do
    assert convert(0.20, from: :prob, to: :us) == "+400", "US"
    assert convert(0.20, from: :prob, to: :eu) == "5.000", "EU"
    assert convert(0.20, from: :prob, to: :uk) == "4/1", "UK"
    assert convert(0.20, from: :prob, to: :id) == "4.000", "ID"
    assert convert(0.20, from: :prob, to: :my) == "-0.250", "MY"
    assert convert(0.20, from: :prob, to: :hk) == "4.000", "HK"
    assert convert(0.20, from: :prob, to: :roi) == "400%", "ROI"
  end

  test "to probability - in the money" do
    assert convert("-400", from: :us, to: :prob) == "80%", "US"
    assert convert(1.25, from: :eu, to: :prob) == "80%", "EU"
    assert convert("1/4", from: :uk, to: :prob) == "80%", "UK"
    assert convert(-4.00, from: :id, to: :prob) == "80%", "ID"
    assert convert(0.25, from: :my, to: :prob) == "80%", "MY"
    assert convert(0.25, from: :hk, to: :prob) == "80%", "HK"
    assert convert(0.25, from: :roi, to: :prob) == "80%", "ROI"
  end

  test "from probability - in the money" do
    assert convert(0.80, from: :prob, to: :us) == "-400", "US"
    assert convert(0.80, from: :prob, to: :eu) == "1.250", "EU"
    assert convert(0.80, from: :prob, to: :uk) == "1/4", "UK"
    assert convert(0.80, from: :prob, to: :id) == "-4.000", "ID"
    assert convert(0.80, from: :prob, to: :my) == "0.250", "MY"
    assert convert(0.80, from: :prob, to: :hk) == "0.250", "HK"
    assert convert(0.80, from: :prob, to: :roi) == "25%", "ROI"
  end

  test "even money representation equivalence cycle" do
    assert convert("50%", from: :prob, to: :uk) == "1/1", "Prob to UK"
    assert convert("1/1", from: :uk, to: :eu) == "2.000", "UK to EU"
    assert convert("2.000", from: :eu, to: :us) == "+100", "EU to US"
    assert convert("+100", from: :us, to: :id) == "-1.000", "US to ID"
    assert convert("-1.000", from: :id, to: :my) == "1.000", "ID to MY"
    assert convert("1.000", from: :my, to: :hk) == "1.000", "MY to HK"
    assert convert("1.000", from: :hk, to: :roi) == "100%", "HK to ROI"
    assert convert("100%", from: :roi, to: :prob) == "50%", "ROI to Prob"
  end

  test "self convert" do
    assert convert(0.6543210, from: :prob, to: :prob) == "65%", "Prob"
    assert convert(400, from: :us, to: :us) == "+400", "US"
    assert convert("1.0", from: :eu, to: :eu) == "1.000", "EU"
    assert convert("4:8", from: :uk, to: :uk) == "1/2", "UK"
    assert convert("-1.1", from: :id, to: :id) == "-1.100", "ID"
    assert convert("-0.1", from: :my, to: :my) == "-0.100", "MY"
    assert convert(4.2, from: :hk, to: :hk) == "4.200", "HK"
    assert convert(1.8, from: :roi, to: :roi) == "180%", "ROI"
  end

  test "nonsensical zeros" do
    assert convert(0, from: :prob, to: :us) == "+0", "US"
    assert convert(0, from: :prob, to: :eu) == "0.000", "EU"
    assert convert(0, from: :prob, to: :uk) == "0/1", "UK"
    assert convert(0, from: :prob, to: :id) == "0.000", "ID"
    assert convert(0, from: :prob, to: :my) == "0.000", "MY"
    assert convert(0, from: :prob, to: :hk) == "0.000", "HK"
    assert convert(0, from: :prob, to: :roi) == "0%", "ROI"
    assert convert("+0", from: :us, to: :eu) == "0.000", "US to EU"
    assert convert("0.0", from: :eu, to: :uk) == "0/1", "EU to UK"
    assert convert("0-1", from: :uk, to: :id) == "0.000", "UK to ID"
    assert convert("-0", from: :id, to: :my) == "0.000", "ID to MY"
    assert convert("-0.00", from: :my, to: :hk) == "0.000", "MY to HK"
    assert convert(0.0, from: :hk, to: :roi) == "0%", "HK to ROI"
    assert convert(0.0, from: :roi, to: :prob) == "0%", "ROI to Prob"
  end

  test "other junk to zero" do
    assert convert("junk", from: :us, to: :uk) == "0/1", "No random strings"
    assert convert("%85", from: :eu, to: :us) == "+0", "Properly formatted percentages"
    assert convert("8*5", from: :us, to: :eu) == "0.000", "No real math"
    assert convert("85-", from: :eu, to: :prob) == "0%", "Signs at the front"
  end

  test "UK-style misinterpreted" do
    assert convert("8-1", from: :eu, to: :uk) == "7/1", "Thinking UK odds are EU is slightly bad."
    assert convert("8-1", from: :us, to: :uk) == "2/25", "Thinking UK odds are US is very bad."
    assert convert("1-1", to: :uk) == "0/1", "Thinking UK odds are probs is deadly."
  end
end
