defmodule Exchat.RegistrationController do
    use Exchat.Web, :controller 
    alias Exchat.User

    @doc """
    ユーザー登録画面の表示
    """
    def new(conn, _params) do
        # changeset関数は、newメソッドのようなもの。Userのデータを返す。
        changeset = User.changeset(%User{})
        # renderの第3引数に値を渡すことで、ビューやテンプレートで値が使用可能になる
        render conn, "new.html", changeset: changeset
    end

    @doc """
    ユーザー登録処理
    """
    def create(conn, %{"user" => user_params}) do
        # フォーム情報user_paramsの値でuserデータを作成
        changeset = User.changeset(%User{}, user_params)

        # ユーザー登録
        case User.create(changeset, Exchat.Repo) do
            {:ok, user} ->
                # バリデーションに成功した場合、userレコードを作成し、ログインし、"/"にリダイレクト
                conn
                |> put_flash(:info, "ようこそ" <> changeset.params["email"])
                |> redirect(to: "/")
            {:error, changeset} -> 
                # バリデーションに失敗した場合、"new.html"を表示
                conn
                |> put_flash(:info, "アカウントを作成できませんでした。。。。")
                |> render("new.html", changeset: changeset)
        end
    end
end