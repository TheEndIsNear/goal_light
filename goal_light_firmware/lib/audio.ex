defmodule GoalLightFirmware.Audio do
  @moduledoc """
  Handles all of the audio controls for the project
  """
  use GenServer
  require Logger

  def start_link(opts \\ %{}) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_) do
    Logger.info("Setting up audio")
    audio_setup()

    {:ok, %{volume: 0}}
  end

  def goal, do: play("AvsGoalSong.wav")
  def intro, do: play("HereComesTheAvalancheSiren.wav")
  def win, do: play("AvsWin!.wav")
  def powerplay, do: play("DillyDilly.wav")
  def full_strength, do: play("PowerUp.wav")

  def set_volume(volume) do
    GenServer.cast(__MODULE__, {:set_volume, volume})
  end

  def stop, do: GenServer.cast(__MODULE__, :stop)

  @impl true
  def handle_cast({:play, file}, state) do
    Logger.info("Playing audio file: #{file}")

    spawn(fn ->
      static_directory_path = Path.join(:code.priv_dir(:goal_light_firmware), "static")

      full_path = Path.join(static_directory_path, file)

      :os.cmd('aplay -q #{full_path}')
    end)

    {:noreply, state}
  end

  def handle_cast({:set_volume, volume}, state) do
    :os.cmd('amixer cset numid=1 #{volume}')
    {:noreply, %{state | volume: volume}}
  end

  @impl true
  def handle_cast(:stop, state) do
    Logger.info("Stopping the audio")
    :os.cmd('killall aplay')

    {:noreply, state}
  end

  defp play(file), do: GenServer.cast(__MODULE__, {:play, file})

  defp audio_setup do
    :os.cmd('amixer cset numid=3 1')
    set_volume(100)
  end
end
