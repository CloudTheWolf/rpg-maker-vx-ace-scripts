#
# CloudTheWolf: DoctorTodd's Auto Save Addon - Better Auto-Save
# Author: CloudTheWolf
# Date (19/06/2023)
# Version: (1.0.0) (VXA)
# Level: N/A
#
# Website: https://cloudthewolf.com/
#
#===============================================================================
#
# Description: Improves on DoctorTodd's Autosave by making it use the last (Final) slot
#              and not updating the Save index.
#
# Credits: Me (CloudTheWolf), DoctorTodd
#
#===============================================================================
#
# Instructions
# Paste above Below both DT's Autosave (and Khas Ultra Lighting, if using this as well)
# 
#     
#===============================================================================
#
# Free for any use as long as I'm credited, and you legitimately obtained Khas Ultra Lighting.
#
#===============================================================================

module DataManager

  #--------------------------------------------------------------------------
  # * Execute Save (No Exception Processing)
  #--------------------------------------------------------------------------  
  def self.save_game_without_rescue(index, auto = false)
    File.open(make_filename(index), "wb") do |file|
      $game_system.on_before_save
      Marshal.dump(make_save_header, file)
      Marshal.dump(make_save_contents, file)
    end
    if !auto then
        @last_savefile_index = index 
    end
    return true
  end
  
  #--------------------------------------------------------------------------
  # * Execute Load (No Exception Processing)
  #--------------------------------------------------------------------------
  def self.load_game_without_rescue(index)
    File.open(make_filename(index), "rb") do |file|
      Marshal.load(file)
      extract_save_contents(Marshal.load(file))
      reload_map_if_updated
      
      @last_savefile_index = index == ToddAutoSaveAce::MAXFILES - 1 ?  0 : index
    end
    return true
  end
  
end

module Autosave
  #--------------------------------------------------------------------------
  # Use last save slot as "Auto Save" and don't update save index
  #--------------------------------------------------------------------------
  def self.call
    DataManager.save_game_without_rescue(ToddAutoSaveAce::MAXFILES - 1,true)
  end
end

#==============================================================================
# ■ Scene_File
#==============================================================================
class Scene_File 
  
  #--------------------------------------------------------------------------
  # ● Create Sprites
  #--------------------------------------------------------------------------
  def create_sprites
    return if !$imported[:mog_monogatari]
    @saving = $game_temp.scene_save
    @file_max = @saving ? FILES_MAX - 1 : FILES_MAX
    @file_max = 1 if FILES_MAX < 1
    create_background
    create_layout
    create_savefile_windows
    create_particles
    @index = DataManager.last_savefile_index 
    @check_prev_index = true
    @savefile_windows[0].selected = true      
  end
end
