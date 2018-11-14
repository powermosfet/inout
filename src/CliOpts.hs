module CliOpts where 

import Options.Applicative
import Data.Monoid ((<>))

data CliOptions = CliOptions
    { inbound :: Maybe String
    , outbound :: Maybe String
    }

options :: Parser CliOptions
options = CliOptions
    <$> optional (strOption
            ( long "in"
              <> short 'i'
              <> metavar "ACCOUNT"
              <> help "print transaction going _into_ ACCOUNT"
            ))
    <*> optional (strOption
            ( long "out"
              <> short 'o'
              <> metavar "ACCOUNT"
              <> help "print transactions going _out_of_ ACCOUNT"
            ))

optionsWithInfo :: ParserInfo CliOptions
optionsWithInfo = info (options <**> helper)
      ( fullDesc <> progDesc "Process hledger transactions" )
