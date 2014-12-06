module Main where

import Graphics.Gloss
import Graphics.Gloss.Interface.FRP.ReactiveBanana
import Reactive.Banana
import Reactive.Banana.Frameworks

import Graphics
import Sprites
import Types


mainBanana :: Frameworks t
           => Event t Float
           -> Event t InputEvent
           -> Moment t (Behavior t Picture)
mainBanana _ _ = return
               $ pure
               $ pictureGrid 20 20
               $ (fmap.fmap) tilePicture initialStage

main :: IO ()
main = playBanana (InWindow "Ludum Dare 31" (640, 480) (800, 50))
                  white
                  60
                  mainBanana
