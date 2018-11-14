module Main where

import Options.Applicative (execParser)

import Lib (inout)
import CliOpts (optionsWithInfo)

main :: IO ()
main = execParser optionsWithInfo >>= inout
