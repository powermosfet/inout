module Lib (inout) where

import Hledger.Data.Types (Transaction, tpostings, pamount, paccount, Journal, jtxns)
import Hledger.Data.Transaction (showTransaction)
import Hledger.Data.Amount (isNegativeMixedAmount)
import Hledger.Read (readJournal)
import Hledger.Read.Common (definputopts)
import Hledger.Utils.Regex (Regexp, regexMatches)
import qualified Data.Text as Text
import CliOpts (CliOptions, inbound, outbound)
import Data.List (intercalate)
import Data.Maybe (fromMaybe, catMaybes)

inout :: CliOptions -> IO ()
inout opts = do
    -- parse Journal from stdin
    eJournal <- getContents >>= readJournal definputopts Nothing . Text.pack
    case eJournal of
        Left err -> putStrLn err

        Right jrn -> putStrLn (processJournal opts jrn)

processJournal :: CliOptions -> Journal -> String
processJournal opts journal =
    let 
        txs = jtxns journal
        checks tx = all (\chk -> chk tx) $ catMaybes [hasPosting not <$> inbound opts, hasPosting id <$> outbound opts]
        filteredTxs = filter checks txs
    in
        intercalate "\n" $ showTransaction <$> filteredTxs

hasPosting :: (Bool -> Bool) -> Regexp -> Transaction -> Bool
hasPosting negative account tx =
    let 
        postings = tpostings tx
        checkSign posting = negative (fromMaybe False (isNegativeMixedAmount (pamount posting)))
        checkAccount posting = regexMatches account (Text.unpack (paccount posting))
        cmp posting = checkSign posting && checkAccount posting
    in
        any cmp postings
