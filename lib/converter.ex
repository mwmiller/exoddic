defmodule Exoddic.Converter do
  @moduledoc """
  Converter behaviour definition
  """

  @doc "Convert to the odds format from probability"
  @callback from_prob(float) :: float

  @doc "Convert to probability from the odds format"
  @callback to_prob(float) :: float

  @doc "Format the value for 'nice' display"
  @callback for_display(float) :: String.t

end
