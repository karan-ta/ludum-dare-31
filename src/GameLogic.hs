module GameLogic where

import Data.List

import Types
import Vec2d


validateTilePos :: Stage -> TilePos -> Maybe Tile
validateTilePos = atV

validateTile :: Inventory -> Tile -> Maybe InventoryChanges
validateTile _     Wall       = Nothing
validateTile []    LockedDoor = Nothing
validateTile (k:_) LockedDoor = Just [ConsumeKey k]
validateTile _     (Key k)    = Just [ReceiveKey k]
validateTile _     _          = Just []

validateMove :: Stage -> Inventory -> TilePos -> Maybe Move
validateMove stage ks tilePos = do
    tile <- validateTilePos stage tilePos
    inventoryChanges <- validateTile ks tile
    return $ Move (consumeTile tile)
                  tilePos
                  (fmap fromIntegral tilePos)
                  inventoryChanges

consumeTile :: Tile -> Tile
consumeTile LockedDoor = UnlockedDoor
consumeTile (Key _)    = Floor
consumeTile tile       = tile

changeTile :: (TilePos, Tile) -> Stage -> Stage
changeTile = uncurry setAtV

changeStage :: LevelChanges -> Stage -> Stage
changeStage = foldr (.) id
            . fmap changeTile

changeInventory :: InventoryChanges -> Inventory -> Inventory
changeInventory = foldr (.) id
                . fmap go
  where
    go :: InventoryChange -> Inventory -> Inventory
    go (ReceiveKey k) = (k:)
    go (ConsumeKey k) = delete k
