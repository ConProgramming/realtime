defmodule RealtimeWeb.ChannelsAuthorization do
  @moduledoc """
  Check connection is authorized to access channel
  """
  require Logger
  import Realtime.Helpers, only: [to_log: 1]

  def authorize(token, jwt_secret, jwt_jwks) when is_binary(token) do
    token
    |> clean_token()
    |> RealtimeWeb.JwtVerification.verify(jwt_secret, jwt_jwks)
  end

  def authorize(_token, _jwt_secret, _jwt_jwks), do: :error

  defp clean_token(token) do
    Regex.replace(~r/\s|\n/, URI.decode(token), "")
  end

  def authorize_conn(token, jwt_secret, jwt_jwks) do
    case authorize(token, jwt_secret, jwt_jwks) do
      {:ok, claims} ->
        required = MapSet.new(["role", "exp"])
        claims_keys = claims |> Map.keys() |> MapSet.new()

        if MapSet.subset?(required, claims_keys) do
          {:ok, claims}
        else
          {:error, "Fields `role` and `exp` are required in JWT"}
        end

      {:error, reason} ->
        {:error, reason}

      error ->
        %{error_code: "ErrorAuthorizingWebsocket", error_message: to_log(error)}
        {:error, :unknown}
    end
  end
end
