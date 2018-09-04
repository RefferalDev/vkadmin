defmodule VkadminWeb.Router do
  use VkadminWeb, :router

  # -----------------pipeline ----------------

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug(Vkadmin.Auth.AuthAccessPipeline)
  end


  # ----------------- scope route ----------------


  scope "/admin", VkadminWeb do
    pipe_through([:browser,:auth]) # Use the default browser stack

    get "/", UserController, :dashboard
    get "/profile", UserController, :profile
    get "/locked", UserController, :locked
    resources "/activity", ActivityController, only: [:index, :show, :delete]
    resources "/user", UserController
    get "/logout", UserController, :logout 
  end


  scope "/", VkadminWeb do
    pipe_through :browser

    get "/", UserController, :redirector
    get "/login", UserController, :login
    post "/login", UserController, :auth   
  end


  # Other scopes may use custom stacks.
  # scope "/api", VkadminWeb do
  #   pipe_through :api
  # end
end
