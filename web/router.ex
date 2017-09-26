defmodule Exchat.Router do
  use Exchat.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  # api用のスコープ(jsonをacceptする)
  pipeline :api do
    plug :accepts, ["json"]
  end

  # htmlページ用のスコープ(htmlをaccept)
  scope "/", Exchat do
    pipe_through :browser # pipeline :browser の処理を行う

    # "GET /"にアクセスすると、PageControllerのindexアクションが呼ばれる
    get "/", PageController, :index
    # "GET /hello"にアクセスすると、HelloControllerのindexアクションが呼ばれる
    get "/hello", HelloController, :index

    # 登録画面表示(new)と登録処理(create)
    get "/register", RegistrationController, :new
    post "/register", RegistrationController, :create

    # ログイン画面表示(:new)、ログイン処理(:create)、ログアウト処理(:delete)
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", Exchat do
  #   pipe_through :api
  # end
end
