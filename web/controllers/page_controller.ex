defmodule Exchat.PageController do
  use Exchat.Web, :controller

  # アクションの前に実行される
  plug :authenticate_user!

  @doc """
  チャット画面を表示
  """
  def index(conn, _params) do
    render conn, "index.html"
  end

  # ログインしていない場合は、ログインページにリダイレクトさせる
  defp authenticate_user!(conn, _params) do
    unless logged_in?(conn) do
      conn
        |> put_flash(:info, "チャット機能を行うにはログインが必要です")
        |> redirect(to: session_path(conn, :new))
    end
    conn  # plug は connを返す必要がある
  end

end
