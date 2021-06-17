ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(ReviewIt.Repo, :manual)

Mox.defmock(ReviewIt.Imgbb.ClientMock, for: ReviewIt.Imgbb.Behaviour)
