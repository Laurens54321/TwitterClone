defmodule TwittercloneWeb.Guardian do
  use Guardian, otp_app: :twitterclone_web

  alias Twitterclone.UserContext

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.user_id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    case UserContext.get_user(id) do
      {:ok, %UserContext.User{} = u} -> {:ok, u}
      _ -> {:error, :resource_not_found}
    end
  end
end
