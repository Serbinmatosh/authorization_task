defmodule AuthorizationTask.Guardian.AuthPipeline do
  @claims %{typ: "access"}

  use Guardian.Plug.Pipeline,
    otp_app: :authorization_task,
    module: AuthorizationTask.Guardian,
    error_handler: AuthorizationTask.Guardian.AuthErrorHandler

    plug(Guardian.Plug.VerifyHeader, claims: @claims, realm: "Bearer")
    plug(Guardian.Plug.EnsureAuthenticated)
    plug(Guardian.Plug.LoadResource, ensure: true)
end
