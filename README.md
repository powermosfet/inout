# inout

A small utility to filter hledger transactions

find all transactions going into or out of a specific account.
This can be useful to verify against monthly bank summaries

## Help output:

```
$ inout --help
Usage: inout [-i|--in ACCOUNT] [-o|--out ACCOUNT]
  Process hledger transactions

Available options:
  -i,--in ACCOUNT          print transaction going _into_ ACCOUNT
  -o,--out ACCOUNT         print transactions going _out_of_ ACCOUNT
  -h,--help                Show this help text
```

## Example:

Find all transactions going into assets:bank in August

```
$ hledger print -p aug | inout --in assets:bank
```
