defmodule GoalLightFirmware do
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

  def win do
    Audio.win()
    GoalLight.win()
  end
end
