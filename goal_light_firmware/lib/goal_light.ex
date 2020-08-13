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
    {:ok, %{gpio: gpio, enabled: false}}
  end

  @impl true
  def handle_cast({:enable, timeout}, %{gpio: gpio, enabled: false} = state) do
    Logger.info("Enabling the relay")
    GPIO.write(gpio, 1)
    :timer.send_after(:timer.seconds(timeout), :goal_end)
    {:noreply, %{state | enabled: true}}
  end

  def handle_cast({:enable, _timeout}, %{enabled: true} = state) do
    Logger.info("Relay already enabled")
    {:noreply, state}
  end

  @impl true
  def handle_cast(:disable, %{gpio: gpio, enabled: true} = state) do
    Logger.info("Disabling the relay")
    GPIO.write(gpio, 0)
    {:noreply, %{state | enabled: false}}
  end

  @impl true
  def handle_cast(:disable, %{enabled: false} = state) do
    Logger.info("Relay already disabled")
    {:noreply, state}
  end

  @impl true
  def handle_info(:goal_end, %{gpio: gpio, enabled: true} = state) do
    Logger.info("Disabling the relay")
    GPIO.write(gpio, 0)
    {:noreply, %{state | enabled: false}}
  end

  @impl true
  def handle_info(:goal_end, %{enabled: false} = state) do
    Logger.info("Goal already ended ")
    {:noreply, state}
  end

  def goal do
    GenServer.cast(__MODULE__, {:enable, 97})
  end

  def intro do
    GenServer.cast(__MODULE__, {:enable, 52})
  end

  def win do
    GenServer.cast(__MODULE__, {:enable, 92})
  end

  def stop do
    GenServer.cast(__MODULE__, :disable)
  end
end
