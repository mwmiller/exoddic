defmodule ExoddicTest do
  use PowerAssert
  import Exoddic
  doctest Exoddic

  test "defaults and options" do
    assert convert(0.50)                                           == "0.5",  ":prob to :prob for display"
    assert convert(0.50, for_display: false)                       == 0.5,    ":prob to :prob not for display"
    assert convert(0.50, to: :us)                                  == "+100", ":prob to :us for display"
    assert convert(0.50, to: :us, for_display: false)              == 100,    ":prob to :us not for display"
    assert convert("+400", from: :us)                              == "0.2",  ":us to :prob for display"
    assert convert("+400", from: :us, for_display: false)          == 0.2,    ":us to :prob not for display"
    assert convert("+400", from: :us, to: :uk)                     == "4/1",  ":us to :uk for display"
    assert convert("+400", from: :us, to: :uk, for_display: false) == 4,      ":us to :uk not for display"
  end

  test "to probability - even money" do
    assert convert("+100", [from: :us, to: :prob]) == "0.5", "US"
    assert convert(2.0, [from: :eu, to: :prob])    == "0.5", "EU"
    assert convert("1/1", [from: :uk, to: :prob])  == "0.5", "UK"
    assert convert(-1.00, [from: :id, to: :prob])  == "0.5", "ID"
    assert convert(1.00, [from: :my, to: :prob])   == "0.5", "MY"
    assert convert(1.00, [from: :hk, to: :prob])   == "0.5", "HK"
  end

  test "from probability - even money" do
    assert convert(0.50, [from: :prob, to: :us]) == "+100",   "US"
    assert convert(0.50, [from: :prob, to: :eu]) == "2.000",  "EU"
    assert convert(0.50, [from: :prob, to: :uk]) == "1/1",    "UK"
    assert convert(0.50, [from: :prob, to: :id]) == "-1.000", "ID"
    assert convert(0.50, [from: :prob, to: :my]) == "1.000",  "MY"
    assert convert(0.50, [from: :prob, to: :hk]) == "1.000",  "HK"
  end

  test "to probability - out of the money" do
    assert convert("+400", [from: :us, to: :prob]) == "0.2", "US"
    assert convert(5.0, [from: :eu, to: :prob])    == "0.2", "EU"
    assert convert("4/1", [from: :uk, to: :prob])  == "0.2", "UK"
    assert convert(4.00, [from: :id, to: :prob])   == "0.2", "ID"
    assert convert(-0.25, [from: :my, to: :prob])  == "0.2", "MY"
    assert convert(4.00, [from: :hk, to: :prob])   == "0.2", "HK"
  end

  test "from probability - out of the money" do
    assert convert(0.20, [from: :prob, to: :us]) == "+400",   "US"
    assert convert(0.20, [from: :prob, to: :eu]) == "5.000",  "EU"
    assert convert(0.20, [from: :prob, to: :uk]) == "4/1",    "UK"
    assert convert(0.20, [from: :prob, to: :id]) == "4.000",  "ID"
    assert convert(0.20, [from: :prob, to: :my]) == "-0.250", "MY"
    assert convert(0.20, [from: :prob, to: :hk]) == "4.000",  "HK"
  end

  test "to probability - in the money" do
    assert convert("-400", [from: :us, to: :prob]) == "0.8", "US"
    assert convert(1.25, [from: :eu, to: :prob])   == "0.8", "EU"
    assert convert("1/4", [from: :uk, to: :prob])  == "0.8", "UK"
    assert convert(-4.00, [from: :id, to: :prob])  == "0.8", "ID"
    assert convert(0.25, [from: :my, to: :prob])   == "0.8", "MY"
    assert convert(0.25, [from: :hk, to: :prob])   == "0.8", "HK"
  end

  test "from probability - in the money" do
    assert convert(0.80, [from: :prob, to: :us])  == "-400",   "US"
    assert convert(0.80, [from: :prob, to: :eu])  == "1.250",  "EU"
    assert convert(0.80, [from: :prob, to: :uk])  == "1/4",    "UK"
    assert convert(0.80, [from: :prob, to: :id])  == "-4.000", "ID"
    assert convert(0.80, [from: :prob, to: :my])  == "0.250",  "MY"
    assert convert(0.80, [from: :prob, to: :hk])  == "0.250",  "HK"
  end

  test "representation equivalence" do
    assert convert(1.20, [from: :eu, to: :us])   == "-500"#,   "EU to US"
    assert convert("7/2", [from: :uk, to: :eu])  == "4.500",  "UK to EU"
    assert convert(-1.25, [from: :id, to: :uk])  == "4/5",    "ID to UK"
    assert convert(-0.8, [from: :my, to: :id])   == "1.250",  "MY to ID"
    assert convert(6.00, [from: :hk, to: :my])   == "-0.167", "HK to MY"
    assert convert("+350", [from: :us, to: :hk]) == "3.500",  "US to HK"
  end

  test "self convert" do
    assert convert(0.6543210, [from: :prob, to: :prob]) == "0.654321", "Prob"
    assert convert(400, [from: :us, to: :us])           == "+400",     "US"
    assert convert("1.0", [from: :eu, to: :eu])         == "1.000",    "EU"
    assert convert(4/8, [from: :uk, to: :uk])           == "1/2",      "UK"
    assert convert("-1.1", [from: :id, to: :id])        == "-1.100",   "ID"
    assert convert("-0.1", [from: :my, to: :my])        == "-0.100",   "MY"
    assert convert(4.2, [from: :hk, to: :hk])           == "4.200",    "HK"
  end


end
