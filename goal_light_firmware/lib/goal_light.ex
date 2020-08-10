defmodule GoalLightFirmware.GoalLight do
  @moduledoc """
  Module for handling the state of the GPIO Output for the relay controlling the Goal Light
  """
  use GenServer

  require Logger
  alias Circuits.GPIO

  def start_link(state \\ %{}) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(_) do
    Logger.info("Opend GPIO Port 17")
    {:ok, gpio} = GPIO.open(17, :output)
    {:ok, %{gpio: gpio}}
  end

  @impl true
  def handle_cast(:goal, %{gpio: gpio} = state) do
    Logger.info("Enabling the relay")
    GPIO.write(gpio, 1)
    :timer.send_after(:timer.seconds(97), :goal_end)
    {:noreply, state}
  end

  @impl true
  def handle_info(:goal_end, %{gpio: gpio} = state) do
    Logger.info("Disabling the relay")
    GPIO.write(gpio, 0)
    {:noreply, state}
  end

  def goal do
    GenServer.cast(__MODULE__, :goal)
  end
end
