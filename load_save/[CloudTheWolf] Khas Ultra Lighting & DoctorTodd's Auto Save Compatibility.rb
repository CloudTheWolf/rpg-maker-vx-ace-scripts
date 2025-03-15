#===============================================================================
#
# CloudTheWolf Khas Ultra Lighting / DoctorTodd's Auto Save Compatibility
# Author: CloudTheWolf
# Date (19/06/2023)
# Version: (1.0.0) (VXA)
# Level: N/A
#
# Website: https://cloudthewolf.com/
#
#===============================================================================
#
# Disclaimer: I know there used to be an offical addon by Khas, however this is
#             no longer available. This script is intended for those that already
#             have the Khas Ultra Lighting script and wish to use DoctorTodd's
#             Auto Save. I can not say how similar to the original Khas script
#             this is, and will not be providing the Khas Ultra Lighting system.
#             If you do not have Khas Ultra Lighting then there are alternatives
#             such as Khas Amazing Lighting or Victor Engine Lighting which are
#             freely available at the time of writing.
#
#===============================================================================
#
# Description: Fixes compatability issues between Khas Ultra Lighting and DT's Auto Save
#
# Credits: Me (CloudTheWolf), Khas, DoctorTodd
#
#===============================================================================
#
# Instructions
# Paste above Below both DT's Autosave and Khas Ultra Lighting
# 
#     
#===============================================================================
#
# Free for any use as long as I'm credited, and you legitimately obtained Khas Ultra Lighting.
#
#===============================================================================

module SceneManager
  
  def self.kul_dispose
    if @scene.is_a?(Scene_Map)
      @scene.spriteset.dispose_ultra_graphics
    else
      @stack.reverse.each do |s|
        if s.is_a?(Scene_Map)
          s.spriteset.dispose_ultra_graphics
          return
        end
      end
    end
  end
  
  def self.kul_restore
    if @scene.is_a?(Scene_Map)
      @scene.spriteset.initialize_ultra_graphics
    else
      @stack.reverse.each do |s|
        if s.is_a?(Scene_Map)
          s.spriteset.initialize_ultra_graphics
          return
        end
      end
    end
  end  
end 

module DataManager
  def self.save_game_without_rescue(index,autosave = false)
    File.open(make_filename(index), "wb") do |file|
      $game_system.on_before_save
      Marshal.dump(make_save_header, file)
      Marshal.dump(make_save_contents, file)
      @last_savefile_index = index if !autosave
    end    
    return true
  end  
end
