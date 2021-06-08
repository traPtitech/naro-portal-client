module Src.Wrapper.Generic where

import Prelude
import Data.Argonaut.Core (Json, stringify)
import Data.Argonaut.Parser (jsonParser)
import Data.Either (Either(..))
import Data.Generic.Rep (class Generic)
import Data.Identity (Identity(..))
import Foreign.Generic (class GenericDecode, class GenericEncode, SumEncoding, defaultOptions, genericDecodeJSON, genericEncodeJSON)
import Src.Wrapper.Exception (convExceptT, error, ExceptT, except, runExceptT)

opts ::
  { fieldTransform :: String -> String
  , sumEncoding :: SumEncoding
  , unwrapSingleArguments :: Boolean
  , unwrapSingleConstructors :: Boolean
  }
opts = defaultOptions { unwrapSingleConstructors = true }

-- | レコードをJSONに変換
recordToJson :: forall m a rep. Applicative m => Generic a rep => GenericEncode rep => a -> ExceptT m Json
recordToJson =
  except
    <<< ( case _ of
          Left x -> Left $ error x
          Right x -> Right x
      )
    <<< jsonParser
    <<< genericEncodeJSON opts

-- | JSONをレコードに変換
jsonToRecord :: forall m a rep. Applicative m => Generic a rep => GenericDecode rep => Json -> ExceptT m a
jsonToRecord =
  except
    <<< (case _ of Identity x -> x)
    <<< runExceptT
    <<< convExceptT
    <<< genericDecodeJSON opts
    <<< stringify
