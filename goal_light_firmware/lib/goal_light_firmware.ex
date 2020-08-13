defmodule GoalLightFirmware do
  @moduledoc """
  Contains all of the API for the overall library
  """
  alias GoalLightFirmware.Audio
  alias GoalLightFirmware.GoalLight

  def intro do
    Audio.intro()
    GoalLight.intro()
  end

  def goal do
    Audio.goal()
    GoalLight.goal()
  end

  def power_play, do: Audio.powerplay()

  def full_strength, do: Audio.full_strength()

  def win do
    Audio.win()
    GoalLight.win()
  end

  def stop do
    Audio.stop()
    GoalLight.stop()
  end
end
