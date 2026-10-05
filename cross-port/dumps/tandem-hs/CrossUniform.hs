-- | The uniform and bounded streams of cross-port/README.md. The workflow adds this file to the
-- port as executable cross-uniform; tools/Dump.hs gives the normals and exponentials.
--
-- > cross-uniform OUT
module Main (main) where

import Data.ByteString.Builder (Builder, doubleLE, hPutBuilder, word32LE)
import Data.Vector.Unboxed qualified as U
import System.Environment (getArgs)
import System.FilePath ((</>))
import System.IO (IOMode (WriteMode), withBinaryFile)
import System.Random.Tandem

main :: IO ()
main = do
  [out] <- getArgs
  save (out </> "uniform.bin") $ \g ->
    let (u, g') = fillWord32 n g
     in bytes word32LE u <> bytes doubleLE (fst (fillDouble n g'))
  save (out </> "bounded.bin") $ \g ->
    let (a, g') = fillBelow32 1000 n g
     in bytes word32LE a <> bytes word32LE (fst (fillBelow32 3221225473 n g'))
  where
    n = 1000000
    save path fills = withBinaryFile path WriteMode $ \h ->
      mapM_ (\p -> hPutBuilder h (fills (seek p (seed (2026 + 7 * 2 ^ (64 :: Int))))))
        [0, 1, 77, 12345, 2 ^ (30 :: Int)]

bytes :: U.Unbox a => (a -> Builder) -> U.Vector a -> Builder
bytes put = U.foldr (\x b -> put x <> b) mempty
