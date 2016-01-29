defmodule Exoddic.Converter do
   use Behaviour

  @doc "Convert to the odds format from probability"
  defcallback from_prob(number) :: number

  @doc "Convert to probability from the odds format"
  defcallback to_prob(number) :: number

  @doc "Format the value for 'nice' display"
  defcallback for_display(float) :: String.t

end
