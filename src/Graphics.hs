{-# LANGUAGE RecordWildCards #-}
module Graphics where

import Data.Monoid
import Graphics.Gloss
import Text.Printf

import Graphics.Gloss.Extra
import Sprites
import Types
import Vec2d


renderHUD :: LevelNumber -> Picture
renderHUD = translate (-315) 200
          . scale 0.2 0.2
          . text
          . printf "Level %d"


insideStage :: Stage -> Picture -> Picture
insideStage = insideGrid 20 20

renderStage :: Stage -> Picture
renderStage = pictureGrid 20 20
            . (fmap.fmap) tilePicture

atStagePos :: V Float -> Picture -> Picture
atStagePos = atGridPos 20 20


renderPlayer :: PlayerGraphics -> Picture
renderPlayer (PlayerGraphics {..}) = guardPicture gPlayerVisible
                                   $ atStagePos gPlayerScreenPos playerPicture


renderInventory :: Inventory -> Picture
renderInventory = translate (-305) 180
                . pictureRow 25
                . fmap (const keyPicture)


renderDebugMessage :: String -> Picture
renderDebugMessage = translate (-315) (-235)
                   . scale 0.1 0.1
                   . text

renderDebugMessages :: [String] -> Picture
renderDebugMessages = pictureCol 11 . fmap renderDebugMessage


renderGameState :: GameState -> Picture
renderGameState (GameState {..}) = renderHUD gLevelNumber
                                <> renderStage gStage
                                <> insideStage gStage (renderPlayer gPlayerGraphics)
                                <> renderInventory gInventory
                                <> renderDebugMessages gDebugMessages
