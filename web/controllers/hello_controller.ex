defmodule Exchat.HelloController do
  # Webのcontrollerモジュールを使用できるようにする(おまじないのようなもの)
  use Exchat.Web, :controller

  # indexアクション
  #  conn - リクエスト情報を保持
  #  params - クエリストリングやフォーム入力などのパラメータ
  def index(conn, _params) do
    # index.html.eexテンプレートを表示する
    render conn, "index.html"
  end
end