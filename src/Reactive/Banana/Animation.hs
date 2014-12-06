{-# LANGUAGE ScopedTypeVariables #-}
module Reactive.Banana.Animation where

import Reactive.Banana
import Reactive.Banana.Frameworks

import Animation


animateB :: forall a t. Frameworks t
         => Behavior t Float
         -> a
         -> Event t (Animation a)
         -> Behavior t a
animateB time x0 startAnim = animatedValue <$> idleValue
                                           <*> currentAnimation
                                           <*> localTime
  where
    idleValue :: Behavior t a
    idleValue = accumB x0 $ const . lastFrame <$> startAnim
    
    lastFrame :: Animation a -> a
    lastFrame anim | isInfinite d = undefined  -- we won't have to hold the last frame
                   | otherwise    = snapshot anim d
      where
        d = duration anim
    
    currentAnimation :: Behavior t (Animation a)
    currentAnimation = accumB mempty $ const <$> startAnim
    
    startTime :: Behavior t Float
    startTime = accumB 0 $ const <$> time <@ startAnim
    
    localTime :: Behavior t Float
    localTime = (-) <$> time <*> startTime