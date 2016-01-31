defmodule ExoddicTest do
  use PowerAssert
  import Exoddic
  doctest Exoddic

  test "defaults and options" do
    assert convert("50.25%")                                       == "50%",  ":prob to :prob for display"
    assert convert("50.25%", for_display: false)                   == 0.5025, ":prob to :prob not for display"
    assert convert(0.50, to: :us)                                  == "+100", ":prob to :us for display"
    assert convert(0.50, to: :us, for_display: false)              == 100,    ":prob to :us not for display"
    assert convert("+400", from: :us)                              == "20%",  ":us to :prob for display"
    assert convert("+400", from: :us, for_display: false)          == 0.2,    ":us to :prob not for display"
    assert convert("+400", from: :us, to: :uk)                     == "4/1",  ":us to :uk for display"
    assert convert("+400", from: :us, to: :uk, for_display: false) == 4,      ":us to :uk not for display"
  end

  test "to probability - even money" do
    assert convert("+100", [from: :us, to: :prob]) == "50%", "US"
    assert convert(2.0, [from: :eu, to: :prob])    == "50%", "EU"
    assert convert("1/1", [from: :uk, to: :prob])  == "50%", "UK"
    assert convert(-1.00, [from: :id, to: :prob])  == "50%", "ID"
    assert convert(1.00, [from: :my, to: :prob])   == "50%", "MY"
    assert convert(1.00, [from: :hk, to: :prob])   == "50%", "HK"
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
    assert convert("+400", [from: :us, to: :prob]) == "20%", "US"
    assert convert(5.0, [from: :eu, to: :prob])    == "20%", "EU"
    assert convert("4/1", [from: :uk, to: :prob])  == "20%", "UK"
    assert convert(4.00, [from: :id, to: :prob])   == "20%", "ID"
    assert convert(-0.25, [from: :my, to: :prob])  == "20%", "MY"
    assert convert(4.00, [from: :hk, to: :prob])   == "20%", "HK"
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
    assert convert("-400", [from: :us, to: :prob]) == "80%", "US"
    assert convert(1.25, [from: :eu, to: :prob])   == "80%", "EU"
    assert convert("1/4", [from: :uk, to: :prob])  == "80%", "UK"
    assert convert(-4.00, [from: :id, to: :prob])  == "80%", "ID"
    assert convert(0.25, [from: :my, to: :prob])   == "80%", "MY"
    assert convert(0.25, [from: :hk, to: :prob])   == "80%", "HK"
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
    assert convert(1.20, [from: :eu, to: :us])   == "-500",   "EU to US"
    assert convert("7/2", [from: :uk, to: :eu])  == "4.500",  "UK to EU"
    assert convert(-1.25, [from: :id, to: :uk])  == "4/5",    "ID to UK"
    assert convert(-0.8, [from: :my, to: :id])   == "1.250",  "MY to ID"
    assert convert(6.00, [from: :hk, to: :my])   == "-0.167", "HK to MY"
    assert convert("+350", [from: :us, to: :hk]) == "3.500",  "US to HK"
  end

  test "self convert" do
    assert convert(0.6543210, [from: :prob, to: :prob]) == "65%",    "Prob"
    assert convert(400, [from: :us, to: :us])           == "+400",   "US"
    assert convert("1.0", [from: :eu, to: :eu])         == "1.000",  "EU"
    assert convert(4/8, [from: :uk, to: :uk])           == "1/2",    "UK"
    assert convert("-1.1", [from: :id, to: :id])        == "-1.100", "ID"
    assert convert("-0.1", [from: :my, to: :my])        == "-0.100", "MY"
    assert convert(4.2, [from: :hk, to: :hk])           == "4.200",  "HK"
  end

  test "nonsensical zeros" do
    assert convert(0, [from: :prob, to: :us])     == "+0",    "US"
    assert convert(0, [from: :prob, to: :eu])     == "0.000", "EU"
    assert convert(0, [from: :prob, to: :uk])     == "0/1",   "UK"
    assert convert(0, [from: :prob, to: :id])     == "0.000", "ID"
    assert convert(0, [from: :prob, to: :my])     == "0.000", "MY"
    assert convert(0, [from: :prob, to: :hk])     == "0.000", "HK"
    assert convert("+0", [from: :us, to: :eu])    == "0.000", "US to EU"
    assert convert("0.0", [from: :eu, to: :uk])   == "0/1",   "EU to UK"
    assert convert("0/1", [from: :uk, to: :id])   == "0.000", "UK to ID"
    assert convert("-0", [from: :id, to: :my])    == "0.000", "ID to MY"
    assert convert("-0.00", [from: :my, to: :hk]) == "0.000", "MY to HK"
    assert convert(0.0, [from: :hk, to: :prob])   == "0%",    "HK to prob"
    assert convert("junk", [from: :us, to: :uk])  == "0/1",   "US to UK"
  end

end
