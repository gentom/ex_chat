// Phoenisではデフォルトで"deps/phoenix/web/static/js/phoenix"に
// JSのSocketクラスが実装されています。そのSocketクラスをimportします。
import {Socket} from "deps/phoenix/web/static/js/phoenix"

// チャットを行うクラス
class MySocket {

  // newのときに呼ばれるコンストラクタ
  constructor() {
    console.log("Initialized")

    // 入力フィールド
    this.$username = $("#username")
    this.$message  = $("#message")

    // 表示領域
    this.$messagesContainer = $("#messages")

    // キー入力イベントの登録
    this.$message.off("keypress").on("keypress", e => {
      if (e.keyCode === 13) { // 13: Enterキー
        // `${変数}` は式展開
        console.log(`[${this.$username.val()}]${this.$message.val()}`)
        // サーバーに"new:messege"というイベント名で、ユーザ名とメッセージを送る
        this.channel.push("new:message", { user: this.$username.val(), body: this.$message.val() })
        // メッセージの入力フィールドをクリア(空)にする
        this.$message.val("")
      }
    })
  }

  // ソケットに接続
  // トークンを受け取り、トークンがない場合はアラートを表示
  // new Socketで接続するときにトークンをサーバー側に送る
  connectSocket(socket_path, token) {
    if (!token) {
      alert("ソケットにつなぐにはトークンが必要です")
      return false
    }

    // "lib/chat_phoenix/endpoint.ex"　に定義してあるソケットパス("/socket")で
    // ソケットに接続すると、UserSocketに接続されます
    this.socket = new Socket(socket_path, { params: { token: token } })
    this.socket.connect()
    this.socket.onClose( e => console.log("Closed connection") )
  }

  // チャネルに接続
  connectChannel(chanel_name) {
    this.channel = this.socket.channel(chanel_name, {})
    this.channel.join()
      .receive("ok", resp => {
        console.log("Joined successfully", resp)
        // Username入力フィールドにユーザのemailを自動的にセットするようにする
        this.$username.val(resp.email)
      })
      .receive("error", resp => {
        console.log("Unable to join", resp)
      })
  }

  // メッセージを画面に表示
  _renderMessage(message) {
    let user = this._sanitize(message.user || "New User")
    let body = this._sanitize(message.body)

    this.$messagesContainer.append(`<p><b>[${user}]</b>: ${body}</p>`)
  }

  // メッセージをサニタイズする
  _sanitize(str) {
    return $("<div/>").text(str).html()
  }

}

$(
  () => {
    // userTokenがある場合のみソケットにつなぐ
    // 本来は、app.html.eexでこのJSを読み込まなくするほうがよさそう
    // そのためにはJSを分割し、PageControllerのindexアクションで読みこむように
    // render_existingを行う必要がある
    if (window.userToken) {
      let my_socket = new MySocket()
      // app.html.eexでセットしたトークンを使ってソケットに接続
      my_socket.connectSocket("/socket", window.userToken)
      my_socket.connectChannel("rooms:lobby")
    }
  }
)

export default MySocket