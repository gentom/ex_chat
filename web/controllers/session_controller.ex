defmodule Exchat.SessionController do
    use Exchat.Web, :controller 
    alias Exchat.User

    @doc """
    ログイン画面の表示
    """
    def new(conn, _params) do
        render conn, "new.html"
    end

    @doc """
    ログイン処理
    """
    def create(conn, %{"session" => session_params}) do
        # Sessionモジュールのlogin関数でログイン可否を判定する
        case Exchat.Session.login(session_params, Exchat.Repo) do
            # ログイン成功の場合、セッションにuser.idを設定し、ホーム("/")にリダイレクトする
            {:ok, user} ->
                conn
                |> put_session(:current_user, user.id)
                |> put_flash(:info, "ログインしました")
                |> redirect(to: "/")
            # errorの場合、ログイン画面を再表示する
            :error ->
                conn 
                |> put_flash(:info, "メールアドレスかパスワードが間違っています")
                |> render("new.html")
        end
    end

    @doc """
    ログアウト処理

    delete_sessionでセッション情報を削除し、ホーム("/")にリダイレクトする
    """
    def delete(conn, _) do 
        conn
        |> delete_session(:current_user)
        |> put_flash(:info, "ログアウトしました")
        |> redirect(to: "/")
    end

end