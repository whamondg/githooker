defmodule Githooker.GithookControllerTest do
  use Githooker.ConnCase
  import ExUnit.CaptureLog

  setup context do
    if context[:loglevel]  do
      Logger.configure([level: context[:loglevel]])

      on_exit fn ->
        Logger.configure([level: :warn])
      end
    end

    :ok
  end

  test "Github deploy events are handled", %{conn: conn} do
    test_event = "deployment"

    result = conn
    |> put_req_header("x-github-event", test_event)
    |> post("/api/githook")

    assert json_response(result, 200) == %{"status" => "OK", "event" => test_event} 
  end

  test "Unknown Github events are not handled", %{conn: conn} do
    test_event = "some_unhandled_event"

    result = conn
    |> put_req_header("x-github-event", test_event)
    |> post("/api/githook")

    assert json_response(result, 400) == %{"status" => "Unknown event", "event" => test_event}
  end

  @tag loglevel: :info
  test "All received GitHub events are logged", %{conn: conn, loglevel: loglevel} do

    test_events = ~w(
      commit_comment create delete deployment deployment_status fork gollum 
      issue_comment issues member membership page_build public pull_request 
      pull_request_review_comment push release repository status team_add watch 
      some_unknown_event
    )

    Enum.map(test_events, fn (test_event) ->
      logs = capture_log([level: loglevel],fn ->
        conn
        |> put_req_header("x-github-event", test_event)
        |> post("/api/githook")
      end)

      assert logs =~ "Received GitHub event: #{test_event}"
    end)
  end

  @tag loglevel: :info
  test "Deployment events are logged", %{conn: conn} do
    test_event = "deployment"

    logs = capture_log([level: :info],fn ->
      conn
      |> put_req_header("x-github-event", test_event)
      |> post("/api/githook")
    end)

    assert logs =~ "Handling deployment event"
  end

  @tag loglevel: :info
  test "Unknown events are logged", %{conn: conn} do
    test_event = "some unknown event"

    logs = capture_log([level: :info],fn ->
      conn
      |> put_req_header("x-github-event", test_event)
      |> post("/api/githook")
    end)

    assert logs =~ "Ignoring unknown event: #{test_event}"
  end
end
