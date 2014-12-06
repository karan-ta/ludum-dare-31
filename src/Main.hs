{-# LANGUAGE ScopedTypeVariables #-}
module Main where

import Graphics.Gloss
import Graphics.Gloss.Interface.FRP.ReactiveBanana
import Reactive.Banana
import Reactive.Banana.Frameworks

import Animation
import Graphics
import Input
import Types
import Vec2d


mainBanana :: forall t. Frameworks t
           => Event t Float
           -> Event t InputEvent
           -> Moment t (Behavior t Picture)
mainBanana timeDeltaEvent inputEvent = return picture
  where
    dirEvent :: Event t (V Int)
    dirEvent = filterJust $ keydown2dir <$> inputEvent
    
    newPos :: Event t TilePos
    newPos = (+) <$> playerTilePos <@> dirEvent
    
    newTile :: Event t Tile
    newTile = filterJust $ atV <$> stage <@> newPos
    
    startEvent :: Event t ()
    startEvent = const () <$> filterE (== Start) newTile
    
    goalEvent :: Event t ()
    goalEvent = const () <$> filterE (== Goal) newTile
    
    
    time :: Behavior t Float
    time = accumB 0 $ (+) <$> timeDeltaEvent
    
    playerAnimation :: Behavior t (Animation ScreenPos)
    playerAnimation = pure (interpolate 1 (fmap fromIntegral goalPosition)
                                          (fmap fromIntegral startPosition))
    
    
    debugEvent :: Event t String
    debugEvent = (const "next level" <$> goalEvent)
         `union` (const "prev level" <$> startEvent)
    
    
    levelNumber :: Behavior t LevelNumber
    levelNumber = accumB 0 $ (const (+ 1) <$> goalEvent)
                     `union` (const (subtract 1) <$> startEvent)
    
    stage :: Behavior t Stage
    stage = pure initialStage
    
    playerTilePos :: Behavior t TilePos
    playerTilePos = accumB startPosition $ (+) <$> dirEvent
    
    playerScreenPos :: Behavior t ScreenPos
    --playerScreenPos = fmap fromIntegral <$> playerTilePos
    playerScreenPos = snapshot <$> playerAnimation <*> time
    
    accumulatedChanges :: Behavior t [LevelChanges]
    accumulatedChanges = pure []
    
    debugMessages :: Behavior t [String]
    debugMessages = accumB [] $ (:) <$> debugEvent
    
    gameState :: Behavior t GameState
    gameState = GameState <$> levelNumber
                          <*> stage
                          <*> playerTilePos
                          <*> playerScreenPos
                          <*> accumulatedChanges
                          <*> debugMessages
    
    picture :: Behavior t Picture
    picture = renderGameState <$> gameState

main :: IO ()
main = playBanana (InWindow "Ludum Dare 31" (640, 480) (800, 50))
                  white
                  60
                  mainBanana
