defmodule Exoddic.Converter do
  use Behaviour
  @moduledoc """
  Converter behaviour definition
  """

  @doc "Convert to the odds format from probability"
  defcallback from_prob(float) :: float

  @doc "Convert to probability from the odds format"
  defcallback to_prob(float) :: float

  @doc "Format the value for 'nice' display"
  defcallback for_display(float) :: String.t

end
