module Types where

import Vec2d


type LevelNumber = Int

data Tile = Start
          | Goal
          | Floor
          | Wall
          | LockedDoor
          | UnlockedDoor
          | Key LevelNumber
  deriving (Show, Eq)

type Stage = [[Tile]]

type LevelChanges = [(V Int, Tile)]

type Player = V Int

data GameState = GameState
  { gLevelNumber :: LevelNumber
  , gStage :: Stage
  , gPlayer :: Player
  , gAccumulatedChanges :: [LevelChanges]
  , gDebugMessages :: [String]
  } deriving (Show, Eq)

startPosition :: Player
startPosition = 0

goalPosition :: Player
goalPosition = 4

initialStage :: [[Tile]]
initialStage = [[Start, Floor, Floor, Floor, Floor]
               ,[Floor, Floor, Floor, Floor, Floor]
               ,[Floor, Floor, Floor, Floor, Floor]
               ,[Floor, Floor, Floor, Floor, Floor]
               ,[Floor, Floor, Floor, Floor, Goal]]

initialGameState :: GameState
initialGameState = GameState 0 initialStage startPosition [] []
