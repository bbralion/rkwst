defmodule RkwstWeb.BinRouter do
  use RkwstWeb, :router

  match(:*, "/*path", RkwstWeb.BinHandler, :handle)
end
