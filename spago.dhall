{-
Welcome to a Spago project!
You can edit this file as you like.

Need help? See the following resources:
- Spago documentation: https://github.com/purescript/spago
- Dhall language tour: https://docs.dhall-lang.org/tutorials/Language-Tour.html

When creating a new Spago project, you can use
`spago init --no-comments` or `spago init -C`
to generate this file without the comments in this block.
-}
{ name = "my-project"
, dependencies =
  [ "aff"
  , "affjax"
  , "argonaut-core"
  , "console"
  , "effect"
  , "either"
  , "foldable-traversable"
  , "foreign-generic"
  , "halogen"
  , "halogen-store"
  , "halogen-subscriptions"
  , "integers"
  , "maybe"
  , "prelude"
  , "psci-support"
  , "routing"
  , "transformers"
  , "web-events"
  , "web-html"
  , "exceptions"
  , "foreign"
  , "identity"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
