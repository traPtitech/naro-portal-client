{-
作った便利な関数をまとめたモジュール
-}
module Library (makeJsonRequest) where

import Prelude
import Data.Argonaut.Parser (jsonParser)
import Foreign.Generic (class GenericEncode, SumEncoding, defaultOptions, genericEncodeJSON)
import Data.Maybe (Maybe)
import Affjax.RequestBody as RequestBody
import Data.Generic.Rep (class Generic)
import Data.Either (hush)

opts ::
  { fieldTransform :: String -> String
  , sumEncoding :: SumEncoding
  , unwrapSingleArguments :: Boolean
  , unwrapSingleConstructors :: Boolean
  }
opts = defaultOptions { unwrapSingleConstructors = true }

-- | レコードをJSONのリクエストへと変換します
makeJsonRequest :: forall a rep. Generic a rep => GenericEncode rep => a -> Maybe RequestBody.RequestBody
makeJsonRequest = map RequestBody.json <<< hush <<< jsonParser <<< genericEncodeJSON opts
