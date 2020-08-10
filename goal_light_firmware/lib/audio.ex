defmodule GoalLightFirmware.Audio do
  use GenServer

  require Logger

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_) do
    Logger.info("Setting up audio")
    audio_setup()

    {:ok, []}
  end

  def goal, do: play("AvsGoalSong.wav")
  def intro, do: play("HereComesTheAvalancheSiren.wav")
  def win, do: play("AvsWin!.wav")

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

  @impl true
  def handle_cast(:stop, state) do
    Logger.info("Stopping the audio")
    :os.cmd('killall aplay')

    {:noreply, state}
  end

  defp play(file), do: GenServer.cast(__MODULE__, {:play, file})

  defp audio_setup do
    :os.cmd('amixer cset numid=3 1')
    :os.cmd('amixer cset numid=1 10')
  end
end
