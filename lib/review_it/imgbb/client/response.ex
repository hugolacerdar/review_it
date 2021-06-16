defmodule ReviewIt.Imgbb.Client.Response do
  @keys [:image_url]
  @enforce_keys @keys

  @derive {Jason.Encoder, only: @keys}

  defstruct @keys

  @type t :: %__MODULE__{image_url: String.t()}

  def build(image_url) do
    %__MODULE__{
      image_url: image_url
    }
  end
end
