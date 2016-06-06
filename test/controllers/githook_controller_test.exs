defmodule Githooker.GithookControllerTest do
  use Githooker.ConnCase
  import ExUnit.CaptureLog

  test "Github deploy events are handled", %{conn: conn} do
    test_github_event = "deployment"

    result = conn
    |> put_req_header("x-github-event", test_github_event)
    |> post("/api/githook")

    assert json_response(result, 200) == %{"status" => "OK", "event" => test_github_event} 
  end

  test "Unknown Github events are not handled", %{conn: conn} do
    test_github_event = "some unhandled event"

    result = conn
    |> put_req_header("x-github-event", test_github_event)
    |> post("/api/githook")

    assert json_response(result, 400) == %{"status" => "Unknown event", "event" => test_github_event}
  end

end
